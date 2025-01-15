FactoryBot.define do
  factory :coupon do
    code { Faker::Commerce.unique.promotion_code(digits: 6) }
    discount_value { rand(1..99) }
    due_date { 1.month.from_now }
    status { [:active, :inactive].sample }
  end
end