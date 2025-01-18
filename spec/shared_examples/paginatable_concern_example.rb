RSpec.shared_examples "paginatable concern" do |factory_name|
  let(:total_records) { 20 }
  let(:default_length) { 10 }
  let(:default_page) { 1 }
  let!(:records) do
    Array.new(total_records) do |i|
      create(factory_name, factory_name == :license ? { key: "unique_key_#{i}" } : {})
    end
  end

  context "default pagination" do
    it "returns default length" do
      result = described_class.paginate
      expect(result.count).to eq(default_length)
    end
  end
end
