require "rails_helper"

describe Storefront::CheckoutProcessorService do
  context "when #call" do
    let!(:user) { create(:user) }

    context "with invalid params" do
      let(:invalid_coupon) { create(:coupon, status: 2) }
      let(:params) { { installments: 1, user_id: user.id, items: []} }

      let(:params_with_invalid_coupon) do
        { installments: 1, user_id: user.id, items: [{ quantity: 1, payed_price: 100, product: create(:product)
        }], coupon_id: 1 }
      end

      it "set error when it order params not present" do
        service = error_proof_call(params)
        expect(service.errors.keys).to match_array(%i[payment_type document items subtotal total_amount])
      end

      it "set error when :items key is empty" do
        params.merge!({ document: '03.000.050/0001-67', payment_type: :billet })
        service = error_proof_call(params)
        expect(service.errors).to have_key(:items)
      end

      it "set error when some :items attribute is not present" do
        params.merge!({ items: [{}], document: '03.000.050/0001-67', payment_type: :billet })
        service = error_proof_call(params)
        expect(service.errors.keys).to match_array(%i[quantity payed_price product])
      end

      it "set error when :items params are invalid" do
        params.merge!({ items: [{ quantity: 0 }], document: '03.000.050/0001-67', payment_type: :billet })
        service = error_proof_call(params)
        expect(service.errors).to have_key(:quantity)
      end

      it "set error when Coupon is invalid" do
        allow(Coupon).to receive(:find_by).and_return(invalid_coupon)
        allow(invalid_coupon).to receive(:validate_use!).and_raise(Coupon::InvalidUse, "Coupon is expired")

        service = described_class.new(params_with_invalid_coupon)
        service.call

        expect(service.errors).to include("Coupon is invalid")
        expect(service.errors).to have_key(:coupon)
        expect(service.errors[:coupon]).to eq("Coupon is expired")
      end

      context "when payment_type is :credit_card" do
        let!(:products) { create_list(:product, 3) }

        let(:params) do
          {
            installments: 1, user_id: user.id, payment_type: :credit_card,
            items: [{ product_id: products.first.id, quantity: 1 }, { product_id: products.second.id, quantity: 1 }]
          }
        end

        it "set error when :address is invalid" do
          service = error_proof_call(params)
          expect(service.errors).to have_key(:address)
        end

        it "set error when address :card_hash is not present" do
          service = error_proof_call(params)
          expect(service.errors).to have_key(:card_hash)
        end
      end
    end

    context "with valid params" do
      let!(:products) { create_list(:product, 3) }
      let!(:coupon) { create(:coupon) }

      let(:params) do
        {
          payment_type: :credit_card, coupon_id: coupon.id, user_id: user.id, installments: 2, document: '03.000.050/0001-67',
          items: [
            { quantity: 2, product_id: products.first.id },
            { quantity: 3, product_id: products.second.id }
          ],
          card_hash: "12345",
          address: attributes_for(:address)
        }
      end

      it "create an Order" do
        params.merge! {}
        service = described_class.new(params)
        expect do
          service.call
        end.to change(Order, :count).by(1)
      end

      it "create Line Items" do
        params.merge! {}
        service = described_class.new(params)
        expect do
          service.call
        end.to change(LineItem, :count).by(2)
      end

      it "set Line Item :payed_price with current Product :price" do
        service = described_class.new(params)
        service.call
        payed_prices = service.order.line_items.pluck(:payed_price)
        expect(payed_prices).to eq [products.first.price, products.second.price]
      end

      it "set Order :subtotal as Line Items #total sum" do
        service = described_class.new(params)
        service.call
        expected_subtotal = service.order.line_items.sum(&:total).floor(2)
        expect(service.order.subtotal).to eq expected_subtotal
      end

      it 'set Order :total_amount as :subtotal with Coupon discount' do
        line_items = [
          build(:line_item, payed_price: 150.00, quantity: 2), # Total: 300.00
          build(:line_item, payed_price: 100.00, quantity: 2)  # Total: 200.00
        ]
        coupon_discount = 50.00 # Desconto aplicado

        order = build(:order, line_items: line_items)
        allow_any_instance_of(Storefront::CheckoutProcessorService).to receive(:order).and_return(order)
        allow_any_instance_of(Storefront::CheckoutProcessorService).to receive(:discount).and_return(coupon_discount)

        service = described_class.new(params)
        service.call

        expected_total_amount = 450.00 # Subtotal (300 + 200) - Discount (50)
        expect(service.order.total_amount).to eq(expected_total_amount)
      end
    end
  end

  def error_proof_call(*params)
    service = described_class.new(*params)
    begin
      service.call
    rescue => e
    end
    return service
  end
end