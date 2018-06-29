module Rql
  module Scope
    class RqlScope
      def initialize(scope)
        @block_methods = BlockMethods.new(scope)
        @param_methods = ParamMethods.new(scope)
        @scope = scope
      end

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

      def merge(other)
        other = other.scope if other.is_a?(RqlScope)
        RqlScope.new(scope.merge(other))
      end

      def arel
        scope.arel
      end

      def to_a
        scope.to_a
      end
    end
  end
end