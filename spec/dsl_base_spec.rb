RSpec.describe Rql::Dsl::Base do
  let(:dsl) {Rql::Dsl::Base.new(Author)}

  describe "responds_to_missing?" do
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
      expect(dsl.total_books).to be_a(Rql::Dsl::Context)
      expect(dsl.total_books.context_name).to be(nil)
      expect(dsl.total_books.model.name).to eq('Author')
    end

    it "should create a context for a normal attribute" do
      expect(dsl.name).to be_a(Rql::Dsl::Context)
      expect(dsl.name.context_name).to eq(:name)
      expect(dsl.name.model.name).to eq('Author')
    end

    it "should create a context for a model" do
      expect(dsl.books).to be_a(Rql::Dsl::Context)
      expect(dsl.books.context_name).to eq(:books)
      expect(dsl.books.model.name).to eq('Author')
    end

    it "should raise an exception for anything else" do
      expect{dsl.database}.to raise_error(NoMethodError)
    end

    context "when params passed" do
      it "should raise an ArgumentError" do
        expect{dsl.name(3)}.to raise_error(ArgumentError)
      end
    end
  end
end