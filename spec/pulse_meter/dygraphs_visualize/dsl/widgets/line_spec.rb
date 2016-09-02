require 'spec_helper'

describe PulseMeter::DygraphsVisualize::DSL::Widgets::Line do
  it_should_behave_like "dsl widget"

  let(:interval){ 100 }
  let(:name) { "some_sensor" }
  let!(:sensor){ PulseMeter::Sensor::Timelined::Max.new(name, :ttl => 1000, :interval => interval) }
  
  let(:widget_name){ "some_widget" }
  let(:w){ described_class.new(widget_name)  }

  describe "#to_data" do
    it "produces PulseMeter::DygraphsVisualize::Widgets::Area class" do
      expect(w.to_data).to be_kind_of(PulseMeter::DygraphsVisualize::Widgets::Line)
    end
  end

  describe "#values_label" do
    it "sets values_label" do
      w.values_label "some y-axis legend"
      expect(w.to_data.values_label).to eq("some y-axis legend")
    end
  end

  describe "#show_last_point" do
    it "sets show_last_point" do
      w.show_last_point true
      expect(w.to_data.show_last_point).to be_truthy
    end
  end

  describe "#timespan" do
    it "sets timespan" do
      w.timespan 5
      expect(w.to_data.timespan).to eq(5)
    end
    it "raises exception if timespan is negative" do
      expect{ w.timespan(-1) }.to raise_exception(PulseMeter::DygraphsVisualize::DSL::BadWidgetTimeSpan)
    end
  end

end

