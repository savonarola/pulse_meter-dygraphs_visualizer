# DygraphsVisualize

require 'pulse_meter/dygraphs_visualize/base'
require 'pulse_meter/dygraphs_visualize/sensor'
require 'pulse_meter/dygraphs_visualize/widget'
require 'pulse_meter/dygraphs_visualize/widgets/timeline'
require 'pulse_meter/dygraphs_visualize/widgets/pie'
require 'pulse_meter/dygraphs_visualize/widgets/gauge'
require 'pulse_meter/dygraphs_visualize/page'
require 'pulse_meter/dygraphs_visualize/layout'

# DSL

require 'pulse_meter/dygraphs_visualize/dsl/errors'
require 'pulse_meter/dygraphs_visualize/dsl/base'
require 'pulse_meter/dygraphs_visualize/dsl/sensor'
require 'pulse_meter/dygraphs_visualize/dsl/widget'
require 'pulse_meter/dygraphs_visualize/dsl/widgets/area'
require 'pulse_meter/dygraphs_visualize/dsl/widgets/line'
require 'pulse_meter/dygraphs_visualize/dsl/widgets/pie'
require 'pulse_meter/dygraphs_visualize/dsl/widgets/table'
require 'pulse_meter/dygraphs_visualize/dsl/widgets/gauge'
require 'pulse_meter/dygraphs_visualize/dsl/page'
require 'pulse_meter/dygraphs_visualize/dsl/layout'

# App

require 'pulse_meter/dygraphs_visualize/app'

module PulseMeter
  class DygraphsVisualizer
    def self.draw(&block)
      layout_cofigurator = PulseMeter::DygraphsVisualize::DSL::Layout.new
      yield(layout_cofigurator)
      layout_cofigurator.to_data
    end
  end
end
