require "spec_helper"

describe PulseMeter::DygraphsVisualize::Sensor do
  let(:interval){ 100 }
  let(:name) { "some_sensor" }
  let(:annotation) { 'sensor descr' }
  let!(:real_sensor){ PulseMeter::Sensor::Timelined::Counter.new(name, ttl: 1000, interval: interval, annotation: annotation) }
  let(:sensor) { described_class.new(name: name) }

  let(:color){ '#ABCDEF' }
  let(:sensor_with_color) { described_class.new(name: name, color: color) }

  let(:bad_sensor) { described_class.new(name: "bad_sensor_name") }
  let(:interval_start){ Time.at((Time.now.to_i / interval) * interval) }

  describe '#last_value' do
    context "when sensor does not exist" do
      it "raises RestoreError" do
        expect{ bad_sensor.last_value(Time.now) }.to raise_exception(PulseMeter::RestoreError)
      end
    end


    context "when sensor has no data" do
      it "returns nil" do
        expect(sensor.last_value(Time.now)).to be_nil
      end
    end

    context "when sensor has data" do
      context "when need_incomplete arg is true" do
        it "returns last value" do
          Timecop.freeze(interval_start) do
            real_sensor.event(101)
          end
          Timecop.freeze(interval_start+1) do
            expect(sensor.last_value(Time.now, true)).to eq(101)
          end
        end
      end

      context "when need_incomplete arg is false" do
        it "returns last complete value" do
          Timecop.freeze(interval_start) do
            real_sensor.event(101)
          end
          Timecop.freeze(interval_start + 1) do
            expect(sensor.last_value(Time.now)).to be_nil
          end
          Timecop.freeze(interval_start + interval + 1) do
            expect(sensor.last_value(Time.now)).to eq(101)
          end
        end
      end

    end
  end

  describe "#last_point_data" do

    context "when sensor does not exist" do
      it "raises RestoreError" do
        expect{ bad_sensor.last_point_data(Time.now) }.to raise_exception(PulseMeter::RestoreError)
      end
    end

    it "returns last value with annotation (and color)" do
      Timecop.freeze(interval_start) do
        real_sensor.event(101)
      end
      Timecop.freeze(interval_start + 1) do
        expect(sensor.last_point_data(Time.now, true)).to eq([{name: annotation, y: 101}])
        expect(sensor.last_point_data(Time.now)).to eq([{name: annotation, y: nil}])
        expect(sensor_with_color.last_point_data(Time.now, true)).to eq([{name: annotation, y: 101, color: color}])
        expect(sensor_with_color.last_point_data(Time.now)).to eq([{name: annotation, y: nil, color: color}])
      end
    end
  end

  describe "valid?" do
    subject{ checked_sensor.valid? }
    context "when sensor exists" do
      let(:checked_sensor){ sensor }
      it{ is_expected.to be_truthy }
    end
    context "when sensor does not exist" do
      let(:checked_sensor){ bad_sensor }
      it{ is_expected.to be_falsey }
    end
  end

  describe "#timeline_data" do
    before(:each) do
      Timecop.freeze(interval_start) do
        real_sensor.event(101)
      end
      Timecop.freeze(interval_start + interval) do
        real_sensor.event(55)
      end
    end

    context "when sensor does not exist" do
      it "raises RestoreError" do
        expect{ bad_sensor.timeline_data(Time.now - interval, Time.now) }.to raise_exception(PulseMeter::RestoreError)
      end
    end


    describe "returned value" do
      it "contains sensor annotation" do
        Timecop.freeze(interval_start + interval + 1) do
          expect(sensor.timeline_data(Time.now - interval, Time.now).first[:name]).to eq(annotation)
        end
      end
      it "contains sensor color" do
        Timecop.freeze(interval_start + interval + 1) do
          expect(sensor_with_color.timeline_data(Time.now - interval, Time.now).first[:color]).to eq(color)
        end
      end

      it "contains [interval_start, value] pairs for each interval" do
        Timecop.freeze(interval_start + interval + 1) do
          data = sensor.timeline_data(Time.now - interval * 2, Time.now)
          expect(data.first[:data]).to eq([{x: interval_start.to_i * 1000, y: 101}])
          data = sensor.timeline_data(Time.now - interval * 2, Time.now, true)
          expect(data.first[:data]).to eq([{x: interval_start.to_i * 1000, y: 101}, {x: (interval_start + interval).to_i * 1000, y: 55}])
        end
      end
    end
  end

end
