RSpec.shared_examples "like searchable concern" do |factory_name, column|
  let!(:record_to_find) { create(factory_name, column => "UniqueQuery") }
  let!(:other_record) { create(factory_name, column => "DifferentQuery") }
  let!(:another_record) { create(factory_name, column => "AnotherQuery") }

  it "returns results matching the search query" do
    result = described_class.search("UniqueQuery")
    expect(result.count).to eq(1)
    expect(result).to include(record_to_find)
    expect(result).not_to include(other_record, another_record)
  end
end

# RSpec.shared_examples "like searchable concern" do |model, searchable_field|
#   let(:factory_name) { model }
#   let(:search_field) { searchable_field }

#   it "returns results matching the search query" do
#     query = "Test"
#     record_to_find = create(factory_name, search_field => query)
#     create(factory_name) # Registro que não deve ser encontrado

#     result = described_class.search(query)
#     expect(result).to include(record_to_find)
#     expect(result.count).to eq(1)
#   end
# end

