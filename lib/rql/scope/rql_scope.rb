module Rql
  module Scope
    class RqlScope
      # @!parse include Rql::Scope::ParamMethods
      # @!parse include Rql::Scope::BlockMethods

      # @param scope [ActiveRecord::Relation] the underlying scope to wrap
      def initialize(scope)
        @block_methods = BlockMethodGroup.new(scope)
        @param_methods = ParamMethodGroup.new(scope)
        @scope = scope
      end

      # Gets the underlying ActiveRecord Relation object for the scope
      #
      # @return [ActiveRecord::Relation] the underlying arel object
      def scope
        @scope
      end

      def method_missing(method_name, *params, &block)
        if block && @block_methods.respond_to?(method_name)
          RqlScope.new(@block_methods.send(method_name, &block))
        elsif @param_methods.respond_to?(method_name)
          RqlScope.new(@param_methods.send(method_name, *params))
        else
          scope.send(method_name, *params)
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        @block_methods.respond_to?(method_name, include_private) ||
          @param_methods.respond_to?(method_name, include_private) ||
          super.respond_to?(method_name, include_private) ||
          super
      end

      # Creates a new scope merging the current scope with the other scope
      #
      # @param [Rql::Scope::RqlScope, ActiveRecord::Relation] other the scope to merge with the current one.
      # @return [Rql::Scope::RqlScope] the new merged scope
      def merge(other)
        other = other.scope if other.is_a?(RqlScope)
        RqlScope.new(scope.merge(other))
      end

      # Gets the underlying arel object for the scope
      #
      # @return [Arel::SelectManager] the underlying arel object
      def arel
        scope.arel
      end

      # Executes the scope against the database returning the results as an array
      #
      # @return [Array] the results as an array
      def to_a
        scope.to_a
      end
    end
  end
end