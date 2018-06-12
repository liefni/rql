module Rql
  module Dsl
    class Context < Base
      include Aggregations
      include Comparisons
      include Maths
      include Orders
      include Logic

      def initialize(model, arel, name = nil, scope = nil)
        @model = model
        @arel = arel
        @name = name
        @scope = scope || model
      end

      def arel
        @arel
      end

      def build_context(name)
        model = @name.to_s.classify.constantize
        Context.new(model, model.arel_table[name], name)
      end

      def as(name)
        Context.new(@model, arel.as(name.to_s))
      end

      def rql
        Context.new(@model, @arel, @name, @scope.rql)
      end

      def where(*attributes, &block)
        Context.new(@model, @arel, @name, @scope.where(*attributes, &block))
      end
    end
  end
end