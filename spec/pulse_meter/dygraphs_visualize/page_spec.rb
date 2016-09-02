require "spec_helper"

describe PulseMeter::DygraphsVisualize::Page do
  let(:interval){ 100 }
  let!(:a_sensor){ PulseMeter::Sensor::Timelined::Counter.new(:a_sensor, :ttl => 1000, :interval => interval, annotation: 'A') }
  let!(:b_sensor){ PulseMeter::Sensor::Timelined::Counter.new(:b_sensor, :ttl => 1000, :interval => interval, annotation: 'B') }

  let(:type) { :some_type }
  let(:widget_name){ "some_widget" }

  let(:redraw_interval){5}
  let(:values_label){'xxxx'}
  let(:width){6}
  let(:show_last_point){false}
  let(:timespan){interval * 2}
  let(:a_color){'#FF0000'}
  let(:b_color){'#FFFF00'}

  let(:interval_start){ Time.at((Time.now.to_i / interval) * interval) }
  let(:page_title){"Dashboard"}


  let(:page) do
    p = PulseMeter::DygraphsVisualize::DSL::Page.new(page_title)
    p.line(widget_name) do |w|
      w.redraw_interval redraw_interval
      w.values_label values_label
      w.width width
      w.show_last_point show_last_point
      w.timespan timespan

      w.sensor :a_sensor, color: a_color
      w.sensor :b_sensor, color: b_color
    end
    p.line(widget_name) do |w|
      w.redraw_interval redraw_interval
      w.values_label values_label
      w.width width
      w.show_last_point show_last_point
      w.timespan timespan

      w.sensor :a_sensor, color: a_color
      w.sensor :b_sensor, color: b_color
    end
    p.to_data
  end

  before(:each) do
    Timecop.freeze(interval_start + 1) do
      a_sensor.event(12)
      b_sensor.event(33)
    end
    Timecop.freeze(interval_start + interval + 1) do
      a_sensor.event(111)
    end
  end

  describe "#widget_data" do

    it "generates correct data of single widget" do
      Timecop.freeze(interval_start + 2 * interval - 1) do
        expect(page.widget_data(0)[:id]).to eq(1)
        expect(page.widget_data(1)[:id]).to eq(2)
      end
    end

    it "generates correct data of single widget" do
      Timecop.freeze(interval_start + 2 * interval - 1) do
        expect(page.widget_data(0)[:series]).to eq(
          {
            titles: [a_sensor.annotation, b_sensor.annotation],
            rows: [[interval_start.to_i * 1000, 12, 33]],
            options: [
              {color: a_color},
              {color: b_color}
            ]
          }
        )
        expect(page.widget_data(1)[:series]).to eq(
          {
            titles: [a_sensor.annotation, b_sensor.annotation],
            rows: [[interval_start.to_i * 1000, 12, 33]],
            options: [
              {color: a_color},
              {color: b_color}
            ]
          }
        )
      end

      Timecop.freeze(interval_start + 2 * interval - 1) do
        expect(page.widget_data(0, timespan: 0)[:series]).to eq(
          {
            titles: [a_sensor.annotation, b_sensor.annotation],
            rows: [],
            options: [
              {color: a_color},
              {color: b_color}
            ]
          }
        )
        expect(page.widget_data(1, timespan: 1)[:series]).to eq(
          {
            titles: [a_sensor.annotation, b_sensor.annotation],
            rows: [],
            options: [
              {color: a_color},
              {color: b_color}
            ]
          }
        )

      end
    end
  end

  describe "#widget_datas" do
    it "generates correct ids for all widgets" do
      Timecop.freeze(interval_start + 2 * interval - 1) do
        expect(page.widget_datas.map{|h| h[:id]}).to eq([1,2])
      end
    end

    it "generates correct series data of all widgets" do
      Timecop.freeze(interval_start + 2 * interval - 1) do

        expect(page.widget_datas.map{|h| h[:series]}).to eq([
          {
            titles: [a_sensor.annotation, b_sensor.annotation],
            rows: [[interval_start.to_i * 1000, 12, 33]],
            options: [
              {color: a_color},
              {color: b_color}
            ]
          },
          {
            titles: [a_sensor.annotation, b_sensor.annotation],
            rows: [[interval_start.to_i * 1000, 12, 33]],
            options: [
              {color: a_color},
              {color: b_color}
            ]
          }
        ])
      end

    end
  end
end
