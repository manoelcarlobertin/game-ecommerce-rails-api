class Coupon < ApplicationRecord
  # include NameSearchable
  # include Paginatable
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :status, presence: true
  validates :discount_value, presence: true, numericality: { greater_than: 0 }
  # simples aplicar uma validação customizada criada por nós =D
  validates :due_date, presence: true, future_date: true

  def validate_use!
    raise InvalidUse, 'Coupon is expired' if expiration_date < Time.current
    raise InvalidUse, 'Coupon is inactive' if status != 'active'
  end

  enum status: { active:1,  inactive: 2 }
end
