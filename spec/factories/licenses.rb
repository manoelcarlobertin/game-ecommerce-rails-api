# spec/factories/licenses.rb
FactoryBot.define do
  factory :license do
    key { "TEST-KEY" }
    platform { 1 } # Supondo que o enum 1 seja válido
    status { 1 }   # Supondo que o enum 1 seja válido
    game
  end
end
