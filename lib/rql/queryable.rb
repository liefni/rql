require "active_support/concern"

module Rql
  module Queryable
    extend ActiveSupport::Concern

    class_methods do
      # Gets an RQL scope object for access to rql query methods
      #
      # @return [Rql::Scope::RqlScope] object wrapping the current scope
      def rql
        return Scope::RqlScope.new(all)
      end

      # Evaluates a block of code against the RQL DSL
      #
      # @param alias_derived_attr [Boolean] value specifying if derived attributes will be assigned an alias
      # @yield the code block to be converted to sql
      # @return [Rql::Dsl::Context] object wrapping arel for the evaluated block of code
      def eval_rql(alias_derived_attr = false, &block)
        Dsl::Base.new(self.unscoped, alias_derived_attr).instance_eval(&block)
      end

      # Defines a derived attribute on a model
      #
      # @param name [Symbol] the name of the derived attribute
      # @yield the code to derive the attribute
      # @!macro [attach] derive_attr
      #   @return [Object] the value of the derived attribute
      def derive_attr(name, &block)
        define_method(name) do
          attributes.has_key?(name.to_s) ? attributes[name.to_s] : instance_eval(&block)
        end

        derived_attributes[name] = block
      end

      # Preloads the specified derived attributes from the database
      #
      # @param attributes [Array<Symbol>] the attributes to be preloaded
      # @return scope including derived attributes
      def derive(*attributes)
        rql.select(self.arel_table[Arel.star], *attributes).all
      end

      # Gets the derived attributes defined on the model
      #
      # @return [Hash<Symbol, Proc>] hash of derived attributes indexed by name
      def derived_attributes
        @derive_attribute ||= {}
      end
    end
  end
end