require 'spec_helper'

describe PulseMeter::DygraphsVisualize::DSL::Sensor do
  let(:interval){ 100 }
  let(:name) { "some_sensor" }
  let!(:sensor){ PulseMeter::Sensor::Timelined::Max.new(name, :ttl => 1000, :interval => interval) }

  describe '.new' do
    it "should save passed name and create DygraphsVisualize::Sensor with it" do
      described_class.new(name).to_data.name.to_s.should == name
    end
  end

  describe '#process_args' do
    it "should pass args transparently to DygraphsVisualize::Sensor" do
      s = described_class.new(name)
      s.process_args color: :red
      s.to_data.color.to_s.should == 'red'
    end
  end

  describe '#to_data' do
    # actually tested above
    it "should convert dsl data to sensor" do
      described_class.new(name).to_data.should be_kind_of(PulseMeter::DygraphsVisualize::Sensor)
    end
  end

end

