module PulseMeter
  module DygraphsVisualize
    module Widgets
      class Error < StandardError; end
      class Timeline < PulseMeter::DygraphsVisualize::Widget

        class NotATimelinedSensorInWidget < PulseMeter::DygraphsVisualize::Error; end
        class DifferentSensorIntervalsInWidget < PulseMeter::DygraphsVisualize::Error; end

        DEFAULT_TIMESPAN = 3600

        def initialize(opts)
          super
          opts[:timespan] ||= DEFAULT_TIMESPAN
        end

        def data(options = {})
          from, till = get_interval_borders(options)
          super().merge({
            values_title: values_label,
            series: series_data(from, till),
            timespan: timespan,
            interval: interval
          })
        end

        protected

        def get_interval_borders(options)
          from = if options[:start_time] && (options[:start_time] > 0)
            Time.at options[:start_time]
          else
            tspan = options[:timespan] || timespan
            Time.now - tspan
          end

          till = if options[:end_time] && (options[:end_time] > 0)
            Time.at options[:end_time]
          else
            Time.now
          end
          [from, till]
        end

        def series_data(from, till)
          ensure_equal_intervals!
          sensor_datas = sensors.map{ |s|
            s.timeline_data(from, till, show_last_point)
          }
          rows = []
          titles = []
          series_options = []
          datas = []
          sensor_datas.each do |sensor_data|
            sensor_data.each do |tl|
              titles << tl[:name]
              series_options << {color: PulseMeter::DygraphsVisualize::SeriesColor.new(tl).color}
              datas << tl[:data]
            end
          end
          unless datas.empty?
            first = datas.shift
            first.each_with_index do |tl_data, row_num|
              rows << datas.each_with_object([tl_data[:x], tl_data[:y]]) do |data_col, row|
                row << data_col[row_num][:y]
              end
            end
          end
          {
            titles: titles,
            rows: rows,
            options: series_options
          }
        end

        def ensure_equal_intervals!
          intervals = []
          sensors.each do |s|
            unless s.type < PulseMeter::Sensor::Timeline
              raise NotATimelinedSensorInWidget, "sensor `#{s.name}' is not timelined"
            end
            intervals << s.interval
          end

          unless intervals.all?{|i| i == intervals.first}
            interval_notice = sensors.map{|s| "#{s.name}: #{s.interval}"}.join(', ')
            raise DifferentSensorIntervalsInWidget, "Sensors with different intervals in a single widget: #{interval_notice}"
          end
        end

        def interval
          if sensors.empty?
            nil
          else
            sensors.first.interval
          end
        end

      end

      class Stack < Timeline; end
      class Line < Timeline; end
      
    end
  end
end

