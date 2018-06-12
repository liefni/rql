module Rql
  module Dsl
    module Maths
      def +(value)
        Context.new(@model, arel + (value.is_a?(Context) ? value.arel : value))
      end

      def -(value)
        Context.new(@model, arel - (value.is_a?(Context) ? value.arel : value))
      end

      def *(value)
        Context.new(@model, arel * (value.is_a?(Context) ? value.arel : value))
      end

      def /(value)
        Context.new(@model, arel / (value.is_a?(Context) ? value.arel : value))
      end
    end
  end
end