module Rql
  module Scope
    module ParamMethods
      # Filters scope based on specified conditions
      #
      # @param conditions [Hash] A hash of attribute => value conditions to filter on. Use nested hashes to filter on associations. Supports ranges and arrays as values.
      # @return [Rql::Scope::RqlScope] a new scope filtered by the specified conditions
      def where(**conditions)
        scope.where(build_conditions(conditions))
      end

      # Specifies attributes to be selected from the database
      #
      # @param attributes [Array] the attributes to select
      # @return [Rql::Scope::RqlScope] a new scope selecting the specified attributes
      def select(*attributes)
        scope.select(*attributes.map{|attr| scope.derived_attributes[attr] ? scope.eval_rql(&scope.derived_attributes[attr]).as(attr).arel : attr})
      end

      # Orders by specified attributes
      #
      # @param attributes [Array] the attributes to order by. Attributes may be a symbol, sql string or a hash specifying attribute and order.
      # @return [Rql::Scope::RqlScope] a new scope ordered by the specified attributes
      def order(*attributes)
        scope.order(*build_order(attributes))
      end

      # Joins to the specified associated models
      #
      # @param attributes [Array] the associations to join to. Use nested hashes to chain joins through associations.
      # @return [Rql::Scope::RqlScope] a new scope joining the specified associations
      def joins(*attributes)
        scope.joins(*attributes)
      end

      # Includes the specified associated models
      #
      # @param attributes [Array] the associations to include. Use nested hashes to include associations of associations.
      # @return [Rql::Scope::RqlScope] a new scope including the specified associations
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

    class ParamMethodGroup < MethodGroup
      include ParamMethods
    end
  end
end
