require 'spec_helper'

describe PulseMeter::DygraphsVisualize::DSL::Page do
  let(:interval){ 100 }
  let(:sensor_name) { "some_sensor" }
  let!(:sensor){ PulseMeter::Sensor::Timelined::Max.new(sensor_name, :ttl => 1000, :interval => interval) }
  let(:title) { "page title" }
  let(:page){ PulseMeter::DygraphsVisualize::DSL::Page.new(title) }

  describe '.new' do
    it "initializes title and widgets" do
      p = page.to_data  
      expect(p.title).to eq(title)
      expect(p.widgets).to eq([])
    end
  end

  [:line, :stack].each do |widget_type|

    describe "##{widget_type}" do
      it "adds #{widget_type} widget initialized by args to widgets" do
        page.send(widget_type, :some_widget_name, sensor: sensor_name, width: 7)
        w = page.to_data.widgets.first
        expect(w.width).to eq(7)
        expect(w.title).to eq("some_widget_name")
        expect(w.sensors.first.name).to eq(sensor_name)
      end
      
      it "adds #{widget_type} widget initialized by block" do
        page.send(widget_type, :some_widget_name) do |w|
          w.sensor(sensor_name)
          w.sensor(sensor_name)
          w.title "foo_widget"
          w.width 7
        end
        w = page.to_data.widgets.first
        expect(w.type).to eq(widget_type.to_s)
        expect(w.width).to eq(7)
        expect(w.title).to eq("foo_widget")
        expect(w.sensors.size).to eq(2)
        expect(w.sensors.first.name).to eq(sensor_name)
        expect(w.sensors.last.name).to eq(sensor_name)
      end
    end
  
  end

  describe "#title" do
    it "sets page title" do
      page.title "Foo Title"
      expect(page.to_data.title).to eq('Foo Title')
    end
  end

  describe "#to_data" do
    it "converts DSL data to DygraphsVisualize::Page" do
      expect(page.to_data).to be_kind_of(PulseMeter::DygraphsVisualize::Page)
    end
  end

end

