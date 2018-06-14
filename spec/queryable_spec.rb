RSpec.describe Rql::Queryable do
  describe "derived_attr" do
    it "defines an attribute on the class" do
      expect(Author.first.total_books).to eq(11)
    end

    it "registers a derived attribute" do

    end

    describe "defined method" do
      context "when the attribute is not preloaded" do
        it "should execute the block" do

        end
      end

      context "when the attribute is preloaded" do
        it "should not execute the block" do

        end
      end
    end
  end

  describe "rql" do
    it "should create a new rql scope to wrap the current scope" do

    end
  end

  describe "eval_rql" do
    it "should eval the block against the rql dsl" do

    end
  end

  describe "derive" do
    it "should select all normal attributes and the specified derived attributes" do

    end
  end

  describe "derived_attributes" do
    it "should return all derived attributes" do

    end
  end
end