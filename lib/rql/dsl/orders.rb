module Rql
  module Dsl
    module Orders
      def desc(flag = true)
        Context.new(@model, flag ? arel.desc : arel.asc)
      end

      def asc(flag = true)
        Context.new(@model, flag ? arel.asc : arel.desc)
      end
    end
  end
end