RSpec.describe Juno::Charge, type: :model do
  it { is_expected.to belong_to :order }
  it { is_expected.to have_many :credit_card_payments }

  # it { is_expected.to validate_presence_of :order }
  # it { is_expected.to validate_presence_of :juno_charge_id }
  # it { is_expected.to validate_presence_of :status }
  # it { is_expected.to validate_presence_of :amount }
  # it { is_expected.to validate_presence_of :due_date }
  # it { is_expected.to validate_presence_of :installments }
  # it { is_expected.to validate_presence_of :payment_type }
  # it { is_expected.to validate_presence_of :fee }
  # it { is_expected.to validate_presence_of :net_amount }
  # it { is_expected.to validate_presence_of :description }
  # it { is_expected.to validate_presence_of :juno_payment_method_id }
  # it { is_expected.to validate_presence_of :juno_payment_method_name }
  # it { is_expected.to validate_presence_of :juno_payment_type }
  # it { is_expected.to validate_presence_of :juno_payment_status }
  # it { is_expected.to validate_presence_of :juno_payment_status_date }
  # it { is_expected.to validate_presence_of :juno_payment_date }
  # it { is_expected.to validate_presence_of :juno_payment_amount }
  # it { is_expected.to validate_presence_of :juno_payment_fee }
  # it { is_expected.to validate_presence_of :juno_payment_net_amount }
  # it { is_expected.to validate_presence_of :juno_payment_transaction_id }
  # it { is_expected.to validate_presence_of :juno_payment_installments }
  # it { is_expected.to validate_presence_of :juno_payment_card_brand }
  # it { is_expected.to validate_presence_of :juno_payment_card_first_digits }
  # it { is_expected.to validate_presence_of :juno_payment_card_last_digits }
  # it { is_expected.to validate_presence_of :juno_payment_card_holder_name }
  # it { is_expected.to validate_presence_of :juno_payment_card_expiration_date }
  # it { is_expected.to validate_presence_of :juno_payment_card_token }
  # it { is_expected.to validate_presence_of :juno_payment_card_cvv }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_street }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_number }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_complement }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_neighborhood }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_city }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_state }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_country }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_postal_code }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_phone_number }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_mobile_phone_number }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_email }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_date_created }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_date_updated }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_status }
  # it { is_expected.to validate_presence_of :juno_payment_card_address_type }

end