FactoryBot.define do
  factory :coupon do
    code { Faker::Commerce.unique.promotion_code(digits: 6) }
    discount_value { rand(1..99) }
    due_date { 1.month.from_now }

    trait :active do
      status { :active }
    end

    trait :inactive do
      status { :inactive }
    end

    trait :high_discount do
      discount_value { rand(50..99) }
    end

    trait :low_discount do
      discount_value { rand(1..10) }
    end

    trait :fixed_discount do
      discount_value { 25 }
    end
  end
end