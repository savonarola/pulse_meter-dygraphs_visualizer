module PulseMeter
  module DygraphsVisualize
    class Base
      def initialize(opts)
        @opts = opts
      end

      def method_missing(name, *args)
        @opts[name.to_sym]
      end
    end
  end
end


