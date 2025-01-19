require_relative "./auth"
require_relative "./request_error"
require_relative "../../config/initializers/juno" # Ajuste o caminho conforme necessário

module JunoApi
  class Charge
    include HTTParty

    PAYMENT_TYPE = { 'billet' => "BOLETO", 'credit_card' => "CREDIT_CARD" }.freeze
    CHARGE_KEYS_TO_KEEP = %i[id code installment_link amount status].freeze

    base_uri File.join(JUNO_RESOURCE_URL, 'charges')

    headers 'Content-Type' => 'application/json'
    headers 'X-Api-Version' => '2'
    headers 'X-Resource-Token' => Rails.application.credentials.dig(:juno, :private_token)

    def initialize
      @auth = Auth.singleton
    end

    def create!(order)
      response = self.class.post(
        "/",
        headers: authorization_header,
        body: prepare_create_body(order).to_json
      )
      raise_error(response) unless response.success?
      organize_response(response)
    end

    private

    attr_reader :auth

    def self.fetch_private_token
      Rails.application.credentials.dig(:juno, :private_token) || raise("JUNO private token is not configured")
    end

    def authorization_header
      { 'Authorization' => "Bearer #{auth.access_token}" }
    end

    def prepare_create_body(order)
      {
        charge: build_charge(order),
        billing: {
          name: order.user.name,
          document: order.document,
          email: order.user.email
        }
      }
    end

    def build_charge(order)
      {
        description: "Order ##{order.id}",
        amount: (order.total_amount / order.installments).floor(2),
        dueDate: order.due_date.strftime("%Y-%m-%d"),
        installments: order.installments,
        discountAmount: order.coupon&.discount_value.to_f,
        paymentTypes: [PAYMENT_TYPE[order.payment_type]]
      }
    end

    def organize_response(response)
      response.parsed_response["_embedded"]["charges"].map do |charge|
        charge.deep_transform_keys!(&:underscore).symbolize_keys
        charge.slice(*CHARGE_KEYS_TO_KEEP)
      end
    end

    def raise_error(response)
      details = response.parsed_response.dig("details")&.map { |detail| detail.transform_keys(&:underscore) }
      raise RequestError.new("Invalid request sent to Juno", details || [])
    rescue NoMethodError
      raise RequestError.new("Invalid request sent to Juno")
    end
  end
end
