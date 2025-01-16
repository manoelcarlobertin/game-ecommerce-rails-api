require 'rails_helper'

RSpec.describe LineItem, type: :model do
  subject { LineItem.new(quantity: 2, payed_price: 5) }

  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_numericality_of(:quantity).only_integer.is_greater_than(0) }

  it { is_expected.to validate_presence_of(:payed_price) }
  it { is_expected.to validate_numericality_of(:payed_price).is_greater_than(0) }

  it { is_expected.to belong_to :order }
  it { is_expected.to belong_to :product }

  it "#total must be :payed_price multiplied by :quantity" do
    payed_price = 153.32
    quantity = 2
    subject = build(:line_items, payed_price: payed_price, quantity: quantity)
    expected_value = payed_price * quantity
  end

  it 'calculates the total as payed_price multiplied by quantity' do
    expected_value = subject.payed_price * subject.quantity
    expect(subject.total).to eq(expected_value)
  end
end