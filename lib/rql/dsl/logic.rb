module Rql
  module Dsl
    module Logic
      def |(value)
        Context.new(@model, arel.or(value.arel))
      end

      def &(value)
        Context.new(@model, arel.and(value.arel))
      end
    end
  end
end