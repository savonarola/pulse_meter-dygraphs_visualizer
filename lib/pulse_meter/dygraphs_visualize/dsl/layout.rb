module PulseMeter
  module DygraphsVisualize
    module DSL
      class Layout < Base
        DEFAULT_TITLE = "Pulse Meter"

        self.data_class = PulseMeter::DygraphsVisualize::Layout

        def initialize
          super()
          self.title(DEFAULT_TITLE)
          self.use_utc(false)
        end

        string_setter :title
        bool_setter :use_utc
        hash_extender :gchart_options

        deprecated_setter :outlier_color
        deprecated_setter :highchart_options

        dsl_array_extender :pages, :page, PulseMeter::DygraphsVisualize::DSL::Page
      end
    end
  end
end

