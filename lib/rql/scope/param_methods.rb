module Rql
  module Scope
    class ParamMethods < MethodGroup
      def where(**conditions)
        scope.where(build_conditions(conditions))
      end

      def select(*attributes)
        scope.select(*attributes.map{|attr| scope.derived_attributes[attr] ? scope.eval_rql(&scope.derived_attributes[attr]).as(attr).arel : attr})
      end

      def order(*attributes)
        scope.order(*build_order(attributes))
      end

      def joins(*attributes)
        scope.joins(*attributes)
      end

      def includes(*attributes)
        scope.includes(*attributes)
      end

      private
        def build_conditions(conditions, table = scope.name.underscore)
          result = nil
          conditions.each do |key, value|
            condition =
              if value.is_a?(Hash)
                build_conditions(value, key)
              elsif value.is_a?(Range)
                scope.eval_rql{send(table).send(key) === value}.arel
              elsif value.is_a?(Array) || value.methods.include?(:arel)
                scope.eval_rql{send(table).send(key).in?(value)}.arel
              else
                scope.eval_rql{send(table).send(key) == value}.arel
              end
            result = result ? result.and(condition) : condition
          end
          result
        end

        def build_order(attributes)
          order_by =
            attributes.map do |attr|
              if attr.is_a?(Symbol)
                scope.eval_rql{send(attr)}.arel
              elsif attr.is_a?(Hash)
                attr.map {|(key, value)| scope.eval_rql{send(key).desc(value.to_sym == :desc)}.arel}
              else
                attr
              end
            end
          order_by.flatten
        end
    end
  end
end
