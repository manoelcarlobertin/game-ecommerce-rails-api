class FutureDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? # Retorna se o valor for nulo ou vazio

    if value <= Time.zone.now
      record.errors.add(attribute, :future_date, message: "deve ser uma data futura")
    end
  end
end