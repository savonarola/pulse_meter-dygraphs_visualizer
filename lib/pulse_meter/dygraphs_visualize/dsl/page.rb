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

        dsl_array_extender :widgets, :line,  PulseMeter::DygraphsVisualize::DSL::Widgets::Line
        dsl_array_extender :widgets, :stack,  PulseMeter::DygraphsVisualize::DSL::Widgets::Stack

        hash_extender :dygraphs_options

        def spline(*args)
          STDERR.puts "DEPRECATION: spline widget is no longer available."
        end
      end
    end
  end
end

