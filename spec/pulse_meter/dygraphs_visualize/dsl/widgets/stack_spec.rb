require 'spec_helper'

describe PulseMeter::DygraphsVisualize::DSL::Widgets::Stack do
  it_should_behave_like "dsl widget"

  let(:interval){ 100 }
  let(:name) { "some_sensor" }
  let!(:sensor){ PulseMeter::Sensor::Timelined::Max.new(name, :ttl => 1000, :interval => interval) }
  
  let(:widget_name){ "some_widget" }
  let(:w){ described_class.new(widget_name)  }

  describe "#to_data" do
    let(:data){ w.to_data }

    it "produces PulseMeter::DygraphsVisualize::Widgets::Stack class" do
      expect(data).to be_kind_of(PulseMeter::DygraphsVisualize::Widgets::Stack)
    end

    describe "dygraphs_options" do
      let(:dygraphs_options){ data.dygraphs_options }

      it "sets stack Dygraphs options" do
        expect(dygraphs_options[:stacked_graph]).to be_truthy
        expect(dygraphs_options[:stacked_graph_na_n_fill]).to eq('inside')
      end
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

