FactoryBot.define do
  factory :address do
    street { Faker::Address.street_name }
    number { Faker::Address.building_number }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    post_code { Faker::Address.postcode }
      # o **Address** não terá nenhum tipo de associação com o banco
    skip_create
      # esse método *create* deixe de existir para este *model*
    initialize_with { new(**attributes) }
  end
end