RSpec.describe "Storefront V1 Checkout as authenticated user", type: :request do
  let(:user) { create(:user, [:admin, :client].sample) }
  let(:auth_header) { auth_header(user) }
  let(:url) { "/storefront/v1/checkouts" }
  let!(:products) { create_list(:product, 3) }

  describe "POST /checkouts" do
    context "with valid params" do
      let!(:coupon) { create(:coupon) }
      let(:valid_params) { build_checkout_params(coupon, products) }

      it "creates a new Order and associated Line Items" do
        expect { post url, headers: auth_header, params: valid_params }
          .to change(Order, :count).by(1)
          .and change(LineItem, :count).by(2)
      end

      it "returns created Order with associated Line Items and Coupon" do
        post url, headers: auth_header, params: valid_params
        expect_order_response(Order.last)
      end

      it "returns success status" do
        post url, headers: auth_header, params: valid_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:invalid_params) { build_invalid_checkout_params(products) }

      it "does not create an Order or any Line Items" do
        expect { post url, headers: auth_header, params: invalid_params }
          .to_not change(Order, :count)
          .and not_change(LineItem, :count)
      end

      it "returns error message with invalid fields" do
        post url, headers: auth_header, params: invalid_params
        expect(body_json['errors']['fields']).to have_key('payment_type')
      end

      it "returns unprocessable_entity status" do
        post url, headers: auth_header, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # Helper methods for building request parameters
  def build_checkout_params(coupon, products)
    {
      checkout: {
        payment_type: :credit_card,
        installments: 2,
        document: '03.000.050/0001-67',
        card_hash: "123456",
        address: attributes_for(:address),
        items: [
          { quantity: 2, product_id: products.first.id },
          { quantity: 3, product_id: products.second.id }
        ],
        coupon_id: coupon.id
      }
    }.to_json
  end

  def build_invalid_checkout_params(products)
    {
      checkout: {
        installments: 2,
        document: '03.000.050/0001-67',
        items: [
          { quantity: 2, product_id: products.first.id },
          { quantity: 3, product_id: products.second.id }
        ]
      }
    }.to_json
  end

  # Helper method to validate order response
  def expect_order_response(order)
    expected_order = order.as_json(only: %i[id payment_type installments])
    expected_order.merge!(
      'subtotal' => order.subtotal.to_f,
      'total_amount' => order.total_amount.to_f
    )
    expect(body_json['order']).to eq(expected_order)
  end
end
