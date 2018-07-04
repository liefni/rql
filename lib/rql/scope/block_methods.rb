module Rql
  module Scope
    module BlockMethods
      # Filters scope based on specified conditions
      #
      # @yield RQL block defining the conditions to filter on
      # @return [Rql::Scope::RqlScope] a new scope filtered by the specified conditions
      def where(&block)
        scope.where(scope.eval_rql(&block).arel)
      end

      # Specifies attributes to be selected from the database
      #
      # @yield RQL block defining the attributes to be selected
      # @return [Rql::Scope::RqlScope] a new scope selecting the specified attributes
      def select(&block)
        scope.select(*build_attributes(true, &block))
      end

      # Plucks the specified attributes, creating and array of values
      #
      # @yield RQL block defining the attributes to be selected
      # @return [Array] an array of values if plucking one value or an array of arrays if plucking multiple values
      def pluck(&block)
        scope.pluck(*build_attributes(true, &block))
      end

      # Orders by specified attributes
      #
      # @yield RQL block defining the attributes order by
      # @return [Rql::Scope::RqlScope] a new scope ordered by the specified attributes
      def order(&block)
        scope.order(*build_attributes(&block))
      end

      # Joins to the specified associated models
      #
      # @yield RQL block defining the associations to join to
      # @return [Rql::Scope::RqlScope] a new scope joining the specified associations
      def joins(&block)
        scope.joins(*build_join_path(&block))
      end

      # Includes the specified associated models
      #
      # @yield RQL block defining the associations to include
      # @return [Rql::Scope::RqlScope] a new scope including the specified associations
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

    class BlockMethodGroup < MethodGroup
      include BlockMethods
    end
  end
end