module Storefront
  class CheckoutProcessorService
    class InvalidParamsError < StandardError; end

    attr_reader :errors, :order

    def initialize(params)
      @params = params
      @order = nil
      @errors = {}
    end

    def call
      check_presence_of_items_param
      check_emptyness_of_items_param
      validate_coupon
      do_checkout
      calculate_total_amount
      raise InvalidParamsError if @errors.present?
    end

    private

class Storefront::CheckoutProcessorService
  def calculate_total_amount
    subtotal = calculate_subtotal
    discount = calculate_coupon_discount(subtotal)
    @order.total_amount = subtotal - discount
  end

  private

  def calculate_subtotal
    @order.line_items.sum { |item| item.payed_price * item.quantity }
  end

  def calculate_coupon_discount(subtotal)
    coupon = Coupon.find_by(code: @params[:coupon_code])
    return 0 unless coupon&.active?

    case coupon.discount_type
    when 'percentage'
      subtotal * (coupon.discount_value / 100.0)
    when 'fixed'
      [coupon.discount_value, subtotal].min
    else
      0
    end
  end
end


    def coupon_discount(subtotal)
      coupon = Coupon.find_by(code: @params[:coupon_code])
      return 0 unless coupon&.active?

      coupon.apply_discount(subtotal)
    end

    def check_presence_of_items_param
      unless @params.has_key?(:items)
        @errors[:items] = I18n.t('storefront/checkout_processor_service.errors.items.presence')
      end
    end

    def check_emptyness_of_items_param
      if @params[:items].blank?
        @errors[:items] = I18n.t('storefront/checkout_processor_service.errors.items.empty')
      end
    end

    def validate_coupon
      coupon = Coupon.find_by(code: @params[:coupon_code])
      return unless coupon

      begin
        coupon.validate_use!
      rescue Coupon::InvalidUse => e
        @errors[:coupon] = e.message # Adiciona o erro ao hash
      end
    end

    def do_checkout
      create_order
    rescue ActiveRecord::RecordInvalid => e
      @errors.merge! e.record.errors.messages
      @errors.merge!(address: e.record.address.errors.messages) if e.record.errors.has_key?(:address)
    end

    def create_order
      Order.transaction do
        @order = instantiate_order
        line_items = @params[:items].map { |line_item_params| instantiate_line_items(line_item_params) }
        save!(line_items)
      end
    rescue ArgumentError => e
      @errors[:base] = e.message
    end

    def instantiate_order
      order_params = @params.slice(:document, :payment_type, :installments, :card_hash, :coupon_id, :user_id)
      order = Order.new(order_params)
      order.address = Address.new(@params[:address])
      order
    end

    def instantiate_line_items(line_item_params)
      line_item = @order.line_items.build(line_item_params)
      line_item.payed_price = line_item.product.price if line_item.product.present?
      line_item.validate!
      line_item
    end

    def save!(line_items)
      @order.subtotal = line_items.sum(&:total).floor(2)
      @order.total_amount = (@order.subtotal * (1 - @coupon.discount_value / 100)).floor(2) if @coupon.present?
      @order.total_amount ||= @order.subtotal
      @order.save!
      line_items.each(&:save!)
    end
  end
end