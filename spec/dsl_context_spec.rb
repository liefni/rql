RSpec.describe Rql::Dsl::Context do
  describe "aggregations" do
    let(:dsl) {Rql::Dsl::Base.new(Author)}

    describe "calculate" do
      it "uses specified aggregate function" do

      end
    end

    describe "sum" do
      it "uses SUM" do

      end
    end

    describe "average" do
      it "uses AVG" do

      end
    end

    describe "minimum" do
      it "uses MIN" do

      end
    end

    describe "maximum" do
      it "uses MAX" do

      end
    end

    describe "count" do
      context "no param" do
        it "counts id column" do

        end
      end

      context "with param" do
        it "counts specified param" do

        end
      end
    end
  end

  describe "comparisons" do
    let(:dsl) {Rql::Dsl::Base.new(Author)}

    describe "==" do
      it "uses equal comparison" do
        expect((dsl.name == 'ABC').arel.to_sql).to eq("\"authors\".\"name\" = 'ABC'")
      end
    end

    describe "===" do
      let(:dsl) {Rql::Dsl::Base.new(Book)}

      context "range start is -infinity" do
        context "range end is infinity" do
          it "does not check column" do
            expect((dsl.pages === (-Float::INFINITY..Float::INFINITY)).arel.to_sql).to eq("1 = 1 AND 1 = 1")
          end
        end

        context "range end is finite" do
          it "checks column is smaller or equal to the end value" do
            expect((dsl.pages === (-Float::INFINITY..100)).arel.to_sql).to eq("1 = 1 AND \"books\".\"pages\" < 100")
          end
        end
      end

      context "range start is finite" do
        context "range end is infinity" do
          it "checks column is larger or equal to the start value" do
            expect((dsl.pages === (5..Float::INFINITY)).arel.to_sql).to eq("\"books\".\"pages\" > 5 AND 1 = 1")
          end
        end

        context "range end is finite" do
          it "checks column is between the start value and the end value" do
            expect((dsl.pages === (3..5)).arel.to_sql).to eq("\"books\".\"pages\" > 3 AND \"books\".\"pages\" < 5")
          end
        end
      end
    end

    describe "<" do
      it "uses lt comparison" do
        expect((dsl.name < 'ABC').arel.to_sql).to eq("\"authors\".\"name\" < 'ABC'")
      end
    end

    describe ">" do
      it "uses gt comparison" do
        expect((dsl.name > 'ABC').arel.to_sql).to eq("\"authors\".\"name\" > 'ABC'")
      end
    end

    describe "<=" do
      it "uses lt/eq comparison" do
        expect((dsl.name <= 'ABC').arel.to_sql).to eq("\"authors\".\"name\" <= 'ABC'")
      end
    end

    describe ">=" do
      it "uses gt/eq comparison" do
        expect((dsl.name >= 'ABC').arel.to_sql).to eq("\"authors\".\"name\" >= 'ABC'")
      end
    end

    describe "start_with?" do
      it "uses like other%" do
        expect(dsl.name.start_with?('ABC').arel.to_sql).to eq("\"authors\".\"name\" ILIKE 'ABC%'")
      end
    end

    describe "end_with?" do
      it "uses like %other" do
        expect(dsl.name.end_with?('ABC').arel.to_sql).to eq("\"authors\".\"name\" ILIKE '%ABC'")
      end
    end

    describe "include?" do
      it "uses like %other%" do
        expect(dsl.name.include?('ABC').arel.to_sql).to eq("\"authors\".\"name\" ILIKE '%ABC%'")
      end
    end

    describe "in?" do
      context "when value is array" do
        it "checks column is in array" do
          expect(dsl.name.in?(['ABC', '123']).arel.to_sql).to eq("\"authors\".\"name\" IN ('ABC', '123')")
        end
      end

      context "when value is query" do
        it "checks column in subquery" do
          expect(dsl.name.in?(Book.select(:name)).arel.to_sql).to eq("\"authors\".\"name\" IN (SELECT \"books\".\"name\" FROM \"books\")")
        end
      end

      context "on object" do
        it "check object is in array" do
          expect('ABC'.in?(['ABC', '123'])).to be(true)
          expect('123'.in?(['ABC', '123'])).to be(true)
          expect('234'.in?(['ABC', '123'])).to be(false)
        end
      end
    end
  end

  describe "logic" do
    let(:dsl) {Rql::Dsl::Base.new(Book)}

    describe "|" do
      it "creates or condition" do
        expect(((dsl.pages == 200) | (dsl.name == "ABC")).arel.to_sql).to eq("(\"books\".\"pages\" = 200 OR \"books\".\"name\" = 'ABC')")
      end
    end

    describe "&" do
      it "creates and condition" do
        expect(((dsl.pages == 200) & (dsl.name == "ABC")).arel.to_sql).to eq("\"books\".\"pages\" = 200 AND \"books\".\"name\" = 'ABC'")
      end
    end
  end

  describe "maths" do
    let(:dsl) {Rql::Dsl::Base.new(Book)}

    describe "+" do
      it "adds to column" do
        expect((dsl.pages + 5).arel.to_sql).to eq("(\"books\".\"pages\" + 5)")
      end
    end

    describe "-" do
      it "subtracts from column" do
        expect((dsl.pages - 5).arel.to_sql).to eq("(\"books\".\"pages\" - 5)")
      end
    end

    describe "*" do
      it "multiplies column" do
        expect((dsl.pages * 5).arel.to_sql).to eq("\"books\".\"pages\" * 5")
      end
    end

    describe "/" do
      it "divides column" do
        expect((dsl.pages / 5).arel.to_sql).to eq("\"books\".\"pages\" / 5")
      end
    end
  end

  describe "orders" do
    let(:dsl) {Rql::Dsl::Base.new(Book)}

    describe "asc" do
      context "when no param" do
        it "orders asc" do
          expect((dsl.pages.asc).arel.to_sql).to eq("\"books\".\"pages\" ASC")
        end
      end

      context "when param is true" do
        it "orders asc" do
          expect((dsl.pages.asc(true)).arel.to_sql).to eq("\"books\".\"pages\" ASC")
        end
      end

      context "when param is false" do
        it "orders desc" do
          expect((dsl.pages.asc(false)).arel.to_sql).to eq("\"books\".\"pages\" DESC")
        end
      end
    end

    describe "desc" do
      context "when no param" do
        it "orders desc" do
          expect((dsl.pages.desc).arel.to_sql).to eq("\"books\".\"pages\" DESC")
        end
      end

      context "when param is true" do
        it "orders desc" do
          expect((dsl.pages.desc(true)).arel.to_sql).to eq("\"books\".\"pages\" DESC")
        end
      end

      context "when param is false" do
        it "orders asc" do
          expect((dsl.pages.desc(false)).arel.to_sql).to eq("\"books\".\"pages\" ASC")
        end
      end
    end
  end
end