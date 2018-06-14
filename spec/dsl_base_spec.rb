RSpec.describe Rql::Dsl::Base do
  describe "responds_to_missing?" do
    let(:dsl) {Rql::Dsl::Base.new(Author)}

    it "should respond to models" do
      expect(dsl.respond_to?(:book)).to be(true)
    end

    it "should respond to normal attributes" do
      expect(dsl.respond_to?(:name)).to be(true)
    end

    it "should respond to derived attributes" do
      expect(dsl.respond_to?(:total_pages)).to be(true)
    end

    it "should not respond to anything else" do
      expect(dsl.respond_to?(:xyz)).to be(false)
    end
  end

  describe "method_missing" do
    it "should create a context for a derived attribute" do

    end

    it "should create a context for a normal attribute" do

    end

    it "should create a context for a model" do

    end

    it "should raise an exception for anything else" do

    end

    context "when params passed" do
      it "should raise an ArgumentError" do

      end
    end
  end
end