module PulseMeter
  module DygraphsVisualize
    module DSL
      class Page < Base
        self.data_class = PulseMeter::DygraphsVisualize::Page 

        def initialize(title = '')
          super()
          self.title(title)
        end

        string_setter :title

        dsl_array_extender :widgets, :area,  PulseMeter::DygraphsVisualize::DSL::Widgets::Area
        dsl_array_extender :widgets, :line,  PulseMeter::DygraphsVisualize::DSL::Widgets::Line
        dsl_array_extender :widgets, :pie,   PulseMeter::DygraphsVisualize::DSL::Widgets::Pie
        dsl_array_extender :widgets, :table, PulseMeter::DygraphsVisualize::DSL::Widgets::Table
        dsl_array_extender :widgets, :gauge, PulseMeter::DygraphsVisualize::DSL::Widgets::Gauge

        hash_extender :gchart_options

        def spline(*args)
          STDERR.puts "DEPRECATION: spline widget is no longer available."
        end

        def highchart_options(*args)
          STDERR.puts "DEPRECATION: highchart_options DSL helper does not take effect anymore, use gchart_options instead"
        end
      end
    end
  end
end

