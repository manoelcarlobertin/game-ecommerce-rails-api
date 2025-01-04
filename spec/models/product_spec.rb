require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "Validations" do
    subject { build(:product) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:image) }

    context "when image is missing" do
      let(:product) { build(:product, image: nil) }

      it "is invalid" do
        expect(product).not_to be_valid
        expect(product.errors[:image]).to include("não pode ficar em branco")
      end
    end
  end

  describe "Associations" do
    subject { build(:product) }

    it { is_expected.to belong_to(:productable) }
    it { is_expected.to have_many(:product_categories).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:product_categories) }
  end
end
