module PulseMeter
  module DygraphsVisualize
    module DSL
      module Widgets
        class Table < PulseMeter::DygraphsVisualize::DSL::Widget
          self.data_class = PulseMeter::DygraphsVisualize::Widgets::Table

          bool_setter :show_last_point

          int_setter :timespan do |ts|
            raise BadWidgetTimeSpan, ts unless ts > 0
          end

        end
      end
    end
  end
end

