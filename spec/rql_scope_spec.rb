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
        expect(Author.rql.order{[total_books, name]}.first.name).to eq("A. E. van Vogt")
        expect(Author.rql.order{[total_books, name]}.offset(9).first.name).to eq("Alice Hoffman")
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
        expect(Author.rql.where(name: 'J. K. Rowling').count).to eq(1)
      end

      context "ranges" do
        context "range start is -infinity" do
          context "range end is infinity" do
            it "returns all records" do
              expect(Author.rql.where(total_books: -Float::INFINITY..Float::INFINITY).count).to eq(Author.count)
            end
          end

          context "range end is finite" do
            it "return all records smaller or equal to the end value" do
              expect(Author.rql.where(total_books: -Float::INFINITY..3).count).to eq(1019)
            end
          end
        end

        context "range start is finite" do
          context "range end is infinity" do
            it "returns all values larger or equal to the start value" do
              expect(Author.rql.where(total_books: 5..Float::INFINITY).count).to eq(27)
            end
          end

          context "range end is finite" do
            it "return all values between the start value and the end value" do
              expect(Author.rql.where(total_books: 3..5).count).to eq(14)
            end
          end
        end
      end

      it "should support arrays" do
        expect(Author.rql.where(total_books: [3, 5, 6]).count).to eq(63)
      end

      it "should support rql sub queries" do
        expect(Author.rql.where(id: Book.rql.where{name.starts_with?('H')}.select(:author_id)).count).to eq(26)
      end

      it "should support sub queries" do
        expect(Author.rql.where(id: Book.rql.where{name.starts_with?('H')}.select(:author_id).all).count).to eq(26)
      end

      it "should support nested hashes" do
        expect(Author.rql.joins(:books).where(book: {name: 'The Hobbit'}).first.name).to eq('J. R. R. Tolkien')
      end
    end

    describe "select" do
      it "should support a derived attribute" do
        expect(Author.rql.select(:total_pages).first.attributes).to include('total_pages')
      end

      it "should support a normal attribute" do
        expect(Author.rql.select(:name).first.name).to be_truthy
        expect(Author.rql.select(:name).first.id).to be_falsey
      end
    end

    describe "order" do
      it "should support a derived attribute" do
        expect(Author.rql.order(:total_books).first.total_books).to eq(0)
        expect(Author.rql.order(:total_books).offset(Author.count - 50).first.total_books).to eq(4)
        expect(Author.rql.order(:total_books).offset(Author.count - 1).first.total_books).to eq(44)
      end

      it "should support a normal attribute" do
        expect(Author.rql.order(:name).first.name).to eq('A. A. Milne')
        expect(Author.rql.order(:name).offset(Author.count - 50).first.name).to eq('Victor Hugo')
        expect(Author.rql.order(:name).offset(Author.count - 1).first.name).to eq('Émile Zola')
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

  describe "arel" do

  end

  it "should support chained scopes" do
    expect(Author.rql.select{total_pages}.order{total_pages.desc}.first.total_pages > 500).to be(true)
  end

  it "should support nested scopes" do
    expect(Author.rql.select{books.rql.where{name.starts_with?('H')}.count.as(:h_books)}.first.h_books).to eq(7)
  end
end