module Rql
  module Dsl
    module Functions
      def downcase
        Context.new(@model, arel.lower, @name)
      end
    end
  end
end