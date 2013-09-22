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

    it "should produce PulseMeter::DygraphsVisualize::Widgets::Stack class" do
      data.should be_kind_of(PulseMeter::DygraphsVisualize::Widgets::Stack)
    end

    describe "dygraphs_options" do
      let(:dygraphs_options){ data.dygraphs_options }

      it "should set stack Dygraphs options" do
        dygraphs_options[:stacked_graph].should be_true
        dygraphs_options[:stacked_graph_na_n_fill].should == 'inside'
      end
    end
  end

  describe "#values_label" do
    it "should set values_label" do
      w.values_label "some y-axis legend"
      w.to_data.values_label.should == "some y-axis legend"
    end
  end

  describe "#show_last_point" do
    it "should set show_last_point" do
      w.show_last_point true
      w.to_data.show_last_point.should be_true
    end
  end

  describe "#timespan" do
    it "should set timespan" do
      w.timespan 5
      w.to_data.timespan.should == 5
    end
    it "should raise exception if timespan is negative" do
      expect{ w.timespan(-1) }.to raise_exception(PulseMeter::DygraphsVisualize::DSL::BadWidgetTimeSpan)
    end
  end

end

