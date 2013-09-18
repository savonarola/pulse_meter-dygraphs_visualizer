require 'spec_helper'

describe PulseMeter::DygraphsVisualize::DSL::Widgets::Gauge do
  it_should_behave_like "dsl widget"

  let(:interval){ 100 }
  let(:name) { "some_sensor" }
  let!(:sensor){ PulseMeter::Sensor::Timelined::Max.new(name, :ttl => 1000, :interval => interval) }
  
  let(:widget_name){ "some_widget" }
  let(:w){ described_class.new(widget_name)  }

  describe "#to_data" do
    it "should produce PulseMeter::DygraphsVisualize::Widgets::Gauge class" do
      w.to_data.should be_kind_of(PulseMeter::DygraphsVisualize::Widgets::Gauge)
    end
  end

end



