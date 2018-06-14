RSpec.describe Rql::Scope::RqlScope do
  describe "block methods" do
    describe "where" do
      it "should filter on conditions" do
        expect(Author.rql.where{total_books > 5}.count).to eq(27)
      end
    end

    describe "select" do
      it "should select a single attribute" do
        expect(Author.rql.select{total_pages}.first.attributes).to include('total_pages')
      end

      it "should select an array of attributes" do
        expect(Author.rql.select{[name, total_pages]}.first.attributes).to include('name', 'total_pages')
      end
    end

    describe "order" do
      it "should order by a single attribute" do
        expect(Author.rql.order{total_books}.first.total_books).to eq(0)
        expect(Author.rql.order{total_books}.offset(Author.count - 50).first.total_books).to eq(4)
        expect(Author.rql.order{total_books}.offset(Author.count - 1).first.total_books).to eq(44)
      end

      it "should order by an array of attributes" do

      end
    end

    describe "joins" do
      it "should support a single join" do

      end

      it "should support a nested join" do

      end
    end

    describe "includes" do
      it "should support a single join" do

      end

      it "should support a nested join" do

      end
    end
  end

  describe "param methods" do
    describe "where" do
      it "should support values" do

      end

      it "should support ranges" do

      end

      it "should support arrays" do

      end

      it "should support sub queries" do

      end

      it "should support nested hashes" do

      end
    end

    describe "select" do
      it "should support a derived attribute" do

      end

      it "should support a normal attribute" do

      end
    end

    describe "order" do
      it "should support a derived attribute" do

      end

      it "should support a normal attribute" do

      end
    end

    describe "joins" do
      it "should join" do

      end
    end

    describe "includes" do
      it "should include" do

      end
    end
  end

  describe "method_missing" do
    it "should pass it to the underlying scope" do

    end
  end

  describe "merge" do
    it "should be able to merge a normal scope" do

    end

    it "should be able to merge an RQL scope" do

    end
  end

  describe "to_a" do

  end

  it "should support chained scopes" do
    expect(Author.rql.select{total_pages}.order{total_pages.desc}.first.total_pages > 500).to be(true)
  end

  it "should support nested scopes" do
    expect(Author.rql.select{books.rql.where{name.starts_with?('H')}.count.as(:h_books)}.first.h_books).to eq(7)
  end
end