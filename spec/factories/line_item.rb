FactoryBot.define do
  factory :line_item do
    payed_price { 100.00 }
    quantity { 1 }
    product { association :product }
    order { association :order }
  end
end

