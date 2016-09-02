require "spec_helper"

describe PulseMeter::DygraphsVisualize::SeriesExtractor do
  let(:interval){ 100 }
  let!(:real_simple_sensor){ PulseMeter::Sensor::Timelined::Counter.new(:simple_sensor,
    ttl: 1000,
    interval: interval,
    annotation: 'simple sensor'
  ) }
  let!(:real_hashed_sensor){ PulseMeter::Sensor::Timelined::HashedCounter.new(:hashed_sensor,
    ttl: 1000,
    interval: interval,
    annotation: 'hashed sensor'
  ) }

  let!(:simple_sensor){PulseMeter::DygraphsVisualize::Sensor.new(name: :simple_sensor)}
  let!(:hashed_sensor){PulseMeter::DygraphsVisualize::Sensor.new(name: :hashed_sensor)}

  describe "simple extractor" do

    let(:extractor) {PulseMeter::DygraphsVisualize.extractor(simple_sensor)}

    it "bes created for simple sensors" do
      expect(extractor).to be_kind_of(PulseMeter::DygraphsVisualize::SeriesExtractor::Simple)
    end

    it "creates point data correctly" do
      expect(extractor.point_data(123)).to eq([{y: 123, name: 'simple sensor'}])
    end

    it "creates timeline data correctly" do
      tl_data = [
        PulseMeter::SensorData.new(Time.at(1), 11),
        PulseMeter::SensorData.new(Time.at(2), "22")
      ]
      expect(extractor.series_data(tl_data)).to eq([{
        name: 'simple sensor',
        data: [{x: 1000, y: 11}, {x: 2000, y: 22}]
      }])
    end

  end

  describe "hash extractor" do
    let(:extractor) {PulseMeter::DygraphsVisualize.extractor(hashed_sensor)}

    it "bes created for hash sensors" do
      expect(extractor).to be_kind_of(PulseMeter::DygraphsVisualize::SeriesExtractor::Hashed)
    end

    it "creates point data correctly" do
      expect(extractor.point_data('{"x": 123, "y": 321}')).to eq([
        {y: 123, name: 'hashed sensor: x'},
        {y: 321, name: 'hashed sensor: y'}
      ])
    end

    it "creates timeline data correctly" do
      tl_data = [
        PulseMeter::SensorData.new(Time.at(1), {"a" => 5, "b" => 6}),
        PulseMeter::SensorData.new(Time.at(2), '{"c": 7, "b": 6}')
      ]
      expect(extractor.series_data(tl_data)).to eq([
        {
          name: 'hashed sensor: a',
          data: [{x: 1000, y: 5}, {x: 2000, y: nil}]
        },
        {
          name: 'hashed sensor: b',
          data: [{x: 1000, y: 6}, {x: 2000, y: 6}]
        },
        {
          name: 'hashed sensor: c',
          data: [{x: 1000, y: nil}, {x: 2000, y: 7}]
        }
      ])
    end
  end

end
