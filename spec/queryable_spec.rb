RSpec.describe Rql::Queryable do
  describe "derived_attr" do
    it "defines an attribute on the class" do
      expect(Author.first.total_books).to eq(11)
    end

    it "registers a derived attribute" do
      expect(Author.derived_attributes.keys).to contain_exactly(:total_books, :total_pages, :total_a_book_pages)
    end

    describe "defined method" do
      context "when the attribute is not preloaded" do
        it "should execute the block" do
          expect(Author.first.total_books).to eq(11)
        end
      end

      context "when the attribute is preloaded" do
        it "should return the attribute value" do
          author = Author.select('*', '53 as total_books').first
          expect(author.total_books).to eq(53)
        end
      end
    end
  end

  describe "rql" do
    it "should create a new rql scope to wrap the current scope" do
      expect(Author.rql).to be_a(Rql::Scope::RqlScope)
      expect(Author.rql.scope.name).to eq('Author')
    end
  end

  describe "eval_rql" do
    it "should eval the block against the rql dsl" do
      expect(Author.eval_rql{name.start_with?('A')}).to be_a_kind_of(Rql::Dsl::Base)
    end
  end

  describe "derive" do
    it "should select all normal attributes and the specified derived attributes" do
      expect(Author.derive(:total_books).first.attributes['total_books']).to eq(11)
    end
  end
end