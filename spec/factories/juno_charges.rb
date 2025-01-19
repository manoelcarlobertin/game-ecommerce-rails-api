# spec/factories/juno_charges.rb
FactoryBot.define do
  factory :juno_charge do
    amount { 100.0 }
    order
    # Adicione outros atributos conforme necessário
  end
end
