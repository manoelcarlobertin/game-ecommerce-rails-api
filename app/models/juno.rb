module Juno
  class Juno::Charge < ApplicationRecord
    belongs_to :order
    has_many :credit_card_payments, class_name: "Juno::CreditCardPayment"
  end

  def self.table_name_prefix
    'juno_'
  end
end
