require "active_support/concern"

module Rql
  module Queryable
    extend ActiveSupport::Concern

    class_methods do
      def rql
        return Scope::RqlScope.new(all)
      end

      def eval_rql(&query)
        Dsl::Base.new(self).instance_eval(&query)
      end

      def derive_attr(name, &query)
        define_method(name) do
          attributes.has_key?(name.to_s) ? attributes[name.to_s] : instance_eval(&query)
        end

        derived_attributes[name] = query
      end

      def derive(*attributes)
        rql.select(self.arel_table[Arel.star], *attributes).all
      end

      def derived_attributes
        @derive_attribute ||= {}
      end
    end
  end
end