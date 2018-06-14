module Rql
  module Dsl
    class Base
      def initialize(model, alias_derived_attr = false)
        @model = model
        @alias_derived_attr = alias_derived_attr
      end

      def respond_to_missing?(method_name, include_private = false)
        derived?(method_name) || model?(method_name) || attribute?(method_name) || super
      end

      def method_missing(method_name, *params)
        if respond_to_missing?(method_name)
          raise ArgumentError.new("wrong number of arguments for `#{method_name}' (given #{params.length}, expected 0)") if (params.length > 0)

          derive(method_name) || build_context(method_name)
        else
          super
        end
      end

      protected
        def build_context(name)
          Context.new(@model, @model.arel_table[name], name)
        end

        def derive(attribute)
          derived = @model.try(:derived_attributes)&.fetch(attribute, nil)
          if derived
            derived = instance_eval(&derived)
            derived = derived.as(attribute.to_s) if derived && @alias_derived_attr
          end
          derived
        end

        def derived?(attribute)
          !!@model.try(:derived_attributes)&.fetch(attribute, nil)
        end

        def model?(attribute)
          (attribute.to_s.classify.constantize rescue nil)&.ancestors&.include?(ActiveRecord::Base)
        end

        def attribute?(attribute)
          @model.column_names.include?(attribute.to_s)
        end
    end
  end
end