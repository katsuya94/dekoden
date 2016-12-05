require "dekoden/version"

module Dekoden
  class Decorator
    def initialize(*args, &blk)
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

      decorated_instance_methods = Module.new
      base_klass.const_set(:DecoratedMethods, decorated_instance_methods)
      base_klass.prepend(decorated_instance_methods)

      decorated_singleton_methods = Module.new
      base_klass.const_set(:DecoratedSingletonMethods, decorated_singleton_methods)
      base_klass.singleton_class.prepend(decorated_singleton_methods)

      base_klass.define_singleton_method(:method_added) do |method_name|
        method = self.instance_method(method_name)
        unless kollection_clients[self].empty?
          decorators = kollection_clients[self].dup
          kollection_clients[self].clear
          decorated_instance_methods.module_eval do
            define_method(method.name) do |*args, &blk|
              Helpers.wrap(decorators) do
                method.bind(self).call(*args, &blk)
              end
            end
          end
        end
        super(method_name)
      end

      base_klass.define_singleton_method(:singleton_method_added) do |method_name|
        method = self.method(method_name)
        unless kollection_clients[self].empty?
          decorators = kollection_clients[self].dup
          kollection_clients[self].clear
          decorated_singleton_methods.module_eval do
            define_method(method.name) do |*args, &blk|
              Helpers.wrap(decorators) do
                method.call(*args, &blk)
              end
            end
          end
        end
        super(method_name)
      end
    end
  end

  module Helpers
    def self.wrap(decorators, &blk)
      if decorator = decorators.first
        decorator.around do
          wrap(decorators.drop(1), &blk)
        end
      else
        blk.call()
      end
    end
  end
end
