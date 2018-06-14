module Rql
  module Scope
    class BlockMethods < MethodGroup
      def where(&block)
        scope.where(scope.eval_rql(&block).arel)
      end

      def select(&block)
        scope.select(*build_attributes(true, &block))
      end

      def order(&block)
        scope.order(*build_attributes(&block))
      end

      def joins(&block)
        scope.joins(*build_join_path(&block))
      end

      def includes(&block)
        scope.includes(*build_join_path(&block))
      end

      private
        def build_join_path(&block)
          joins = PathBuilder.new.instance_eval(&block)
          joins = [joins] unless joins.is_a?(Array)
          joins.map(&:to_h)
        end

        def build_attributes(alias_derived_attr = false, &block)
          attributes = scope.eval_rql(alias_derived_attr, &block)
          attributes = [attributes] unless attributes.is_a?(Array)
          attributes.map(&:arel)
        end
    end
  end
end