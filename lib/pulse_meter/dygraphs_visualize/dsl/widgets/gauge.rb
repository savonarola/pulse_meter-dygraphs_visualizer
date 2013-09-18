module PulseMeter
  module DygraphsVisualize
    module DSL
      module Widgets
        class Gauge < PulseMeter::DygraphsVisualize::DSL::Widget
          self.data_class = PulseMeter::DygraphsVisualize::Widgets::Gauge
        end
      end
    end
  end
end

