class ProductSerializer < ActiveModel::Serializer
  attributes :id, :description, :price, :status, :release_date, :productable_type

  has_many :categories
  has_one :productable, serializer: ProductableSerializer
end
