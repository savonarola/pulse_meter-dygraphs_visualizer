shared_examples_for "widget" do
  let(:interval){ 100 }
  let!(:a_sensor){ PulseMeter::Sensor::Timelined::Counter.new(:a_sensor, :ttl => 1000, :interval => interval, annotation: 'A') }
  let!(:b_sensor){ PulseMeter::Sensor::Timelined::Counter.new(:b_sensor, :ttl => 1000, :interval => interval, annotation: 'B') }

  let(:widget_name){ "some_widget" }

  let(:redraw_interval){5}
  let(:values_label){'xxxx'}
  let(:width){6}
  let(:timespan){interval * 2}
  let(:a_color){'#FF0000'}
  let(:b_color){'#FFFF00'}

  let(:interval_start){ Time.at((Time.now.to_i / interval) * interval) }

  def constantize(const_name)
    const_name.to_s.split('::').reduce(Module, :const_get)
  end

  def class_name
    described_class.to_s.split('::').last
  end

  def dsl_class
    constantize "PulseMeter::DygraphsVisualize::DSL::Widgets::#{class_name}"
  end

  let(:widget) do
    w = dsl_class.new(widget_name)
    w.redraw_interval redraw_interval
    w.width width
    w.sensor :a_sensor, color: a_color
    w.sensor :b_sensor, color: b_color
    w.dygraphs_options a: 1
    w.timespan timespan
    w.to_data
  end

  describe "#data" do
    it "should contain type, title, redraw_interval, width, dygraphs_options, timespan attriutes" do
      wdata = widget.data
      wdata[:type].should == class_name.downcase
      wdata[:title].should == widget_name
      wdata[:redraw_interval].should == redraw_interval
      wdata[:width].should == width
      wdata[:dygraphs_options][:a].should == 1
      wdata[:timespan].should == timespan
      wdata[:interval].should == interval
    end

    describe "series attribute" do
      before(:each) do
        Timecop.freeze(interval_start + 1) do
          a_sensor.event(12)
          b_sensor.event(33)
        end
        Timecop.freeze(interval_start + interval + 1) do
          a_sensor.event(111)
        end
        @current_time = interval_start + 2 * interval - 1
      end

      it "should contain valid series" do
        Timecop.freeze(@current_time) do
          widget.data[:series].should ==
            {
              titles: [a_sensor.annotation, b_sensor.annotation],
              rows: [[interval_start.to_i * 1000, 12, 33]],
              options: [
                {color: a_color},
                {color: b_color}
              ]
            }
        end
      end

      it "should accept custom timespan" do
        Timecop.freeze(@current_time + interval) do
          widget.data(timespan: timespan)[:series][:rows].size.should == 1
          widget.data(timespan: timespan + interval)[:series][:rows].size.should == 2
        end
      end

      it "should accept start_time and end_time" do
        Timecop.freeze(@current_time + interval) do
          widget.data(start_time: (Time.now - timespan).to_i)[:series][:rows].size.should == 1
          widget.data(
            start_time: (Time.now - interval - timespan).to_i,
            end_time: Time.now.to_i
          )[:series][:rows].size.should == 2
        end
      end

    end
  end
end
