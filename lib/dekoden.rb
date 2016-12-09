require "dekoden/version"

module Dekoden
  module SingletonPrependMethods
    def method_added(method_name)
      unless unbound_decorators.empty?
        decorators_for_method = unbound_decorators.dup
        unbound_decorators.clear
        decorated_methods.module_eval do
          define_method(method_name) do |*args, &blk|
            Helpers.wrap(decorators_for_method, *args, blk) do |*args, blk|
              super(*args, &blk)
            end
          end
        end
      end
      super
    end

    def singleton_method_added(method_name)
      unless unbound_decorators.empty?
        decorators_for_method = unbound_decorators.dup
        unbound_decorators.clear
        decorated_singleton_methods.module_eval do
          define_method(method_name) do |*args, &blk|
            Helpers.wrap(decorators_for_method, *args, blk) do |*args, blk|
              super(*args, &blk)
            end
          end
        end
      end
      super
    end
  end

  module Decoratable
    def decorators(*mojules)
      mojules.each do |mojule|
        mojule.constants.each do |constant|
          decorator_klass = mojule.const_get(constant)
          define_singleton_method(constant) do |*args, &blk|
            unbound_decorators << decorator_klass.new(*args, &blk)
          end
        end
      end
    end

    def unbound_decorators
      @unbound_decorators ||= []
    end

    def decorated_methods
      unless const_defined?(:DecoratedMethods, false)
        mojule = Module.new
        self.prepend(mojule)
        self.const_set(:DecoratedMethods, mojule)
      end
      self.const_get(:DecoratedMethods)
    end

    def decorated_singleton_methods
      unless const_defined?(:DecoratedSingletonMethods, false)
        mojule = Module.new
        self.singleton_class.prepend(mojule)
        self.const_set(:DecoratedSingletonMethods, mojule)
      end
      self.const_get(:DecoratedSingletonMethods)
    end

    def self.extended(mojule)
      mojule.singleton_class.prepend(SingletonPrependMethods)
    end

    def self.included(mojule)
      mojule.prepend(SingletonPrependMethods)
    end
  end

  module Helpers
    def self.wrap(decorators, *args, blk, &block)
      if decorator = decorators.first
        decorator.call(*args, blk) do |*args, blk|
          wrap(decorators.drop(1), *args, blk, &block)
        end
      else
        block.call(*args, blk)
      end
    end
  end
end
