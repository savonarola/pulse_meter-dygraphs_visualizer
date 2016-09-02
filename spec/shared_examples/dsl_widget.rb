shared_examples_for "dsl widget" do

  let(:interval){ 100 }
  let(:name) { "some_sensor" }
  let!(:sensor){ PulseMeter::Sensor::Timelined::Max.new(name, :ttl => 1000, :interval => interval) }

  let(:widget_name){ "some_widget" }
  let(:w){ described_class.new(widget_name)  }

  describe '.new' do
    it "should set default value for width papram" do
      wid = w.to_data
      expect(wid.width).to eq(PulseMeter::DygraphsVisualize::DSL::Widget::MAX_WIDTH)
    end

    it "should set title param from .new argument" do
      wid = w.to_data
      expect(wid.title).to eq(widget_name)
    end
  end

  describe "#process_args" do
    it "should set sensor by :sensor param" do
      w.process_args :sensor => :some_sensor
      sensors = w.to_data.sensors
      expect(sensors.size).to eq(1)
      expect(sensors.first.name.to_s).to eq('some_sensor')
    end

    it "should set title by :title param" do
      w.process_args :title => 'Title XXX'
      expect(w.to_data.title).to eq('Title XXX')
    end

    it "should set width by :width param" do
      w.process_args :width => 5
      expect(w.to_data.width).to eq(5)
    end

  end

  describe "#sensor" do
    let!(:s1){ PulseMeter::Sensor::Timelined::Max.new('s1', :ttl => 1000, :interval => interval) }
    let!(:s2){ PulseMeter::Sensor::Timelined::Max.new('s2', :ttl => 1000, :interval => interval) }


    it "should add sensor" do
      w.sensor :s1
      w.sensor :s2
      sensors = w.to_data.sensors
      expect(sensors.size).to eq(2)
      expect(sensors.first.name.to_s).to eq('s1')
      expect(sensors.last.name.to_s).to eq('s2')
    end
  end

  describe "#title" do
    it "should set title" do
      w.title 'Title XXX'
      expect(w.to_data.title).to eq('Title XXX')
      w.title 'Title YYY'
      expect(w.to_data.title).to eq('Title YYY')
    end
  end

  describe "#width" do
    it "should set width" do
      w.width 6
      expect(w.to_data.width).to eq(6)
    end

    it "should raise exception if width is invalid" do
      expect { w.width -1 }.to raise_exception(PulseMeter::DygraphsVisualize::DSL::BadWidgetWidth)
      expect { w.width 13 }.to raise_exception(PulseMeter::DygraphsVisualize::DSL::BadWidgetWidth)
    end
  end

  describe "#redraw_interval" do
    it "should set redraw_interval" do
      w.redraw_interval 5
      expect(w.to_data.redraw_interval).to eq(5)
    end
    it "should raise exception if redraw_interval is negative" do
      expect{ w.redraw_interval(-1) }.to raise_exception(PulseMeter::DygraphsVisualize::DSL::BadWidgetRedrawInterval)
    end

  end

  describe "#to_data" do
    it "should convert dsl data to widget" do
      expect(w.to_data).to be_kind_of(PulseMeter::DygraphsVisualize::Widget)
    end
  end

  describe "#dygraphs_options" do
    it "should add options to dygraphs_options hash" do
      w.dygraphs_options a: 1
      w.dygraphs_options b: 2
      expect(w.to_data.dygraphs_options).to include(a: 1, b: 2)
    end
  end

  describe "any anknown method" do
    it "should add options to dygraphs_options hash" do
      w.foobar 123
      expect(w.to_data.dygraphs_options[:foobar]).to eq(123)
    end
  end
end

