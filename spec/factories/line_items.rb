FactoryBot.define do
  factory :line_items do
    quantity { 1 }
    payed_price { "9.99" }
    order { nil }
    product { nil }
  end
end
