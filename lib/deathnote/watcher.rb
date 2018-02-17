require "set"
require "active_support"
require "active_support/core_ext"

module Deathnote
  class Watcher
    CLASS_METHOD_SYMBOL = ".".freeze
    INSTANCE_METHOD_SYMBOL = "#".freeze
    PATTERN = /\A(?<symbol>[#{CLASS_METHOD_SYMBOL}#{INSTANCE_METHOD_SYMBOL}])(?<method_name>.+)\z/

    def initialize(callback)
      @callback = callback
    end

    def patch_const(full_class_name, observe_methods)
      if full_class_name == "main"
        return
      end
      unless Object.const_defined?(full_class_name)
        warn "#{full_class_name} is not required"
        return
      end

      callback = @callback
      klass = full_class_name.constantize

      klass.class_eval do
        observe_methods.each do |observe_method|
          next unless (md = PATTERN.match(observe_method))
          symbol = md[:symbol]
          method_name = md[:method_name].to_sym
          target_alias = "#{full_class_name}#{symbol}#{method_name}"

          case symbol
          when INSTANCE_METHOD_SYMBOL
            next unless klass.instance_methods.include?(method_name)
            backuped_method_name = "__origin__#{method_name}"

            alias_method backuped_method_name, method_name
            define_method(method_name) do |*args|
              klass.send(:remove_method, method_name)
              klass.send(:alias_method, method_name, backuped_method_name)

              callback.call(target_alias)

              send(backuped_method_name, *args)
            end
          when CLASS_METHOD_SYMBOL
            next unless klass.respond_to?(method_name)
            singleton_class = klass.singleton_class
            klass.singleton_class.class_eval do
              backuped_method_name = "__origin__#{method_name}"

              alias_method backuped_method_name, method_name
              define_method(method_name) do |*args|
                singleton_class.send(:remove_method, method_name)
                singleton_class.send(:alias_method, method_name, backuped_method_name)

                callback.call(target_alias)

                send(backuped_method_name, *args)
              end
            end
          end
        end
      end
    end
  end
end
