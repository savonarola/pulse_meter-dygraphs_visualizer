module PulseMeter
  module DygraphsVisualize
    module DSL
      module Widgets
        class Pie < PulseMeter::DygraphsVisualize::DSL::Widget
          self.data_class = PulseMeter::DygraphsVisualize::Widgets::Pie

          string_setter :values_label
          bool_setter :show_last_point

        end
      end
    end
  end
end

