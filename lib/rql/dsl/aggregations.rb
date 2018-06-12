module Rql
  module Dsl
    module Aggregations
      def calculate(attribute, operation)
        association = @name.to_s.classify.constantize
        sum_table_name = "#{@model.name.underscore}_#{attribute}_#{operation.to_s.pluralize}"
        subquery = @scope.joins(@name).group(:id).select(:id, association.arel_table[attribute].send(operation)).arel.as(sum_table_name)
        query = Arel.sql("COALESCE((#{@model.from(subquery).where(@model.arel_table[:id].eq(subquery[:id])).select(subquery[operation]).to_sql}), 0)")
        Context.new(@model, query)
      end

      def sum(attribute)
        calculate(attribute, :sum)
      end

      def average(attribute)
        calculate(attribute, :average)
      end

      def minimum(attribute)
        calculate(attribute, :minimum)
      end

      def maximum(attribute)
        calculate(attribute, :maximum)
      end

      def count(attribute = :id)
        calculate(attribute, :count)
      end
    end
  end
end