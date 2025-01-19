require "rails_helper"
require_relative "../../../lib/juno_api/charge"

describe JunoApi::Charge do
  let!(:order) { create(:order) }

  describe "#create!" do
    before(:each) do
      singleton = double(access_token: SecureRandom.hex)
      allow(JunoApi::Auth).to receive(:singleton).and_return(singleton)
    end

    context "with invalid params" do
      it "raises a RequestError" do
        error = { details: [{ message: "Some error", errorCode: "10000" }] }.to_json
        error_response = instance_double(HTTParty::Response, code: 400, body: error, parsed_response: JSON.parse(error), success?: false)
        allow(JunoApi::Charge).to receive(:post).and_return(error_response)

        expect do
          described_class.new.create!(order)
        end.to raise_error(JunoApi::RequestError)
      end
    end

    context "with valid params" do
      let(:return_from_api) do
        installment_to_pay = (order.total_amount / order.installments).round(2)
        charges = 0.upto(order.installments - 1).map do |num|
        {
          id: "000#{num}",
          code: num,
          dueDate: (order.due_date + num.months).strftime("%Y-%m-%d"),
          reference: "",
          amount: installment_to_pay,
          checkoutUrl: Faker::Internet.url(host: 'checkout.juno.com'),
          status: "ACTIVE",
          _links: { self: { href: Faker::Internet.url(host: 'checkout.juno.com') } }
        }
      end
      { _embedded: { charges: charges } }.to_json
    end

      before(:each) do
        api_response = instance_double(HTTParty::Response, code: 200, body: return_from_api, parsed_response: JSON.parse(return_from_api), success?: true)
        allow(JunoApi::Charge).to receive(:post).and_return(api_response)
      end

      it "returns the same number of charges as installments" do
        charges = described_class.new.create!(order)
        expect(charges.count).to eq order.installments
      end

      it "ensures all charges have the same installment amount" do
        charges = described_class.new.create!(order)
        installment_amount = charges.map { |charge| charge[:amount] }.uniq
        expect(installment_amount.size).to eq 1
      end

      it "ensures each installment has the correct amount" do
        installment_for_payment = (order.total_amount / order.installments).round(2)
        charges = described_class.new.create!(order)

        charges.each do |charge|
          # A comparação é feita entre o valor esperado e o valor de amount convertido para float
          expect(charge[:amount]).to eq(installment_for_payment)
        end
      end
    end
  end
end
