module PulseMeter
  module DygraphsVisualize
    module DSL
      module Widgets
        class Stack < PulseMeter::DygraphsVisualize::DSL::Widget
          def initialize(*args)
            super
            dygraphs_options({
              stacked_graph: true,
              stacked_graph_na_n_fill: 'inside'
            })
          end

          self.data_class = PulseMeter::DygraphsVisualize::Widgets::Stack

          string_setter :values_label
          bool_setter :show_last_point
          array_setter :filter_keys

          int_setter :timespan do |ts|
            raise BadWidgetTimeSpan, ts unless ts > 0
          end

        end
      end
    end
  end
end


