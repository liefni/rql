module Rql
  module Dsl
    class Context < Base
      include Aggregations
      include Comparisons
      include Maths
      include Orders
      include Logic
      include Functions

      attr_accessor :arel, :scope, :model

      def initialize(scope, arel, name = nil)
        @scope = scope
        @model = scope.unscoped
        @arel = arel
        @name = name
      end

      def context_name
        @name
      end

      def build_context(name)
        model = @name.to_s.classify.constantize
        Context.new(model, model.arel_table[name], name)
      end

      def as(name)
        Context.new(@model, arel.as(name.to_s))
      end

      def rql
        Context.new(@scope.rql, @arel, @name)
      end

      def where(*attributes, &block)
        model = @name.to_s.classify.constantize
        model = model.rql if @scope.is_a?(Scope::RqlScope)
        Context.new(@scope.merge(model.where(*attributes, &block)), @arel, @name)
      end
    end
  end
end