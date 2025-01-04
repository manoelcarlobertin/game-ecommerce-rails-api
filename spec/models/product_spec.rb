require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }
  it { is_expected.to belong_to :productable }
  it { is_expected.to have_many(:product_categories).dependent(:destroy) }
  it { is_expected.to have_many(:categories).through(:product_categories) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  it { is_expected.to validate_presence_of(:image) }

  it 'is not valid without an image' do
    product = build(:product, image: nil) # Cria um produto sem imagem
    expect(product).not_to be_valid         # Verifica se o produto não é válido
    expect(product.errors[:image]).to include("can't be blank") # Verifica a mensagem de erro
  end
end
