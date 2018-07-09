module Rql
  module Dsl
    module Comparisons
      def ==(value)
        Context.new(@model, arel.eq(value))
      end

      def !=(value)
        Context.new(@model, arel.not_eq(value))
      end

      def ===(range)
        min_query = (range.min != -Float::INFINITY) ? arel.gt(range.min) : Arel.sql('1').eq(1)
        max_query = (range.max != Float::INFINITY) ? arel.lt(range.max) : Arel.sql('1').eq(1)
        Context.new(@model, min_query.and(max_query))
      end

      def <(value)
        Context.new(@model, arel.lt(value))
      end

      def >(value)
        Context.new(@model, arel.gt(value))
      end

      def <=(value)
        Context.new(@model, arel.lteq(value))
      end

      def >=(value)
        Context.new(@model, arel.gteq(value))
      end

      def =~(value)
        Context.new(@model, arel.matches_regexp(value.source, !value.casefold?))
      end

      def start_with?(value)
        Context.new(@model, arel.matches("#{value}%", nil, true))
      end

      def end_with?(value)
        Context.new(@model, arel.matches("%#{value}", nil, true))
      end

      def include?(value)
        Context.new(@model, arel.matches("%#{value}%", nil, true))
      end

      def in?(collection)
        collection = collection.is_a?(Array) ? collection : collection.arel
        Context.new(@model, arel.in(collection))
      end
    end
  end
end

class Object
  def in?(collection)
    collection.include?(self)
  end
end