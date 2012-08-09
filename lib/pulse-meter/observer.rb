require 'pulse-meter'

module PulseMeter
  class Observer
    class << self
      def unobserve_method(klass, method)
        with_observer = method_with_observer(method)
        without_observer = method_without_observer(method)

        return unless klass.method_defined? with_observer
        klass.send :alias_method, method, without_observer
        klass.send :remove_method, with_observer
        klass.send :remove_method, without_observer
      end

      def observe_method_with_sensor(klass, method, sensor, &proc)
        with_observer = method_with_observer(method)
        without_observer = method_without_observer(method)

        if klass.method_defined? with_observer
          return # avoid double observation
        end
            
        klass.send :alias_method, without_observer, method
        klass.send :define_method, with_observer do |*args|
          result = nil
          begin
            sensor.instance_exec *args, &proc
          rescue Exception
          ensure
            result = self.send without_observer, *args
          end
          result
        end
        klass.send :alias_method, method, with_observer
      end

      private

      def method_with_observer(method)
        (method.to_s + "_with_observer").to_sym
      end

      def method_without_observer(method)
        without_observer = (method.to_s + "_without_observer").to_sym
      end
    end
  end
end
