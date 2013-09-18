module PulseMeter
  module DygraphsVisualize
    module DSL
      class Widget < Base
        MAX_WIDTH = 12

        self.data_class = PulseMeter::DygraphsVisualize::Widget

        def initialize(title)
          super()
          self.title(title)
          self.width(MAX_WIDTH)
        end

        hash_extender :gchart_options
       
        string_setter :title

        int_setter :redraw_interval do |int|
          raise BadWidgetRedrawInterval, int unless int > 0
        end
        
        int_setter :width do |w|
          raise BadWidgetWidth, w unless w > 0 && w <= MAX_WIDTH
        end

        dsl_array_extender :sensors, :sensor, PulseMeter::DygraphsVisualize::DSL::Sensor

        def method_missing(name, value)
          gchart_options(name => value)
        end

      end
    end
  end
end

