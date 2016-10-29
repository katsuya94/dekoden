require "dekomori/version"

module Dekomori
  class Decorator
    def initialize(*args, &blk)
    end

    def wrap(decorated_methods, raw_method)
      decorator = self
      decorated_methods.module_eval do
        define_method(raw_method.name) do |*args, &blk|
          decorator.around do
            raw_method.bind(self).call(*args, &blk)
          end
        end
      end
    end

    def around
      yield
    end
  end

  class Collection < Module
    def initialize
      @clients = {}
      @decorator_methods = Module.new
      kollection_clients = @clients
      kollection_decorator_methods = @decorator_methods

      base_decorator_klass = Class.new(Decorator)

      base_decorator_klass.define_singleton_method(:inherited) do |decorator_klass|
        kollection_decorator_methods.module_eval do
          define_method(decorator_klass.to_s.to_sym) do |*args, &blk|
            decorator = decorator_klass.new(*args, &blk)
            kollection_clients[self] << decorator
            decorator
          end
        end
      end

      const_set(:Decorator, base_decorator_klass)
    end

    def included(base_klass)
      @clients[base_klass] = []
      kollection_clients = @clients

      base_klass.extend(@decorator_methods)

      decorated_methods = Module.new
      base_klass.const_set(:DecoratedMethods, decorated_methods)
      base_klass.prepend(decorated_methods)

      base_klass.define_singleton_method(:method_added) do |method_name|
        raw_method = self.instance_method(method_name)
        while decorator = kollection_clients[self].pop
          decorator.wrap(decorated_methods, raw_method)
        end
        super(method_name)
      end
    end
  end
end
