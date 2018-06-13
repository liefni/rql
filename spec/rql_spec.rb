RSpec.describe Rql do
  it "has a version number" do
    expect(Rql::VERSION).not_to be nil
  end

  it "can find a book" do
    expect(Book.first).to be_truthy
  end
end
