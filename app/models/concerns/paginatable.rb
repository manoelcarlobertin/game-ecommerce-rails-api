module Paginatable
  extend ActiveSupport::Concern

  MAX_PER_PAGE = 10
  DEFAULT_PAGE = 1


  included do
    scope :paginate, -> (page = DEFAULT_PAGE, length = MAX_PER_PAGE) do
      page = page.present? && page.to_i.positive? ? page.to_i : DEFAULT_PAGE
      length = length.present? && length.to_i.positive? ? length.to_i : MAX_PER_PAGE
      starts_at = (page - 1) * length
      order(:id).limit(length).offset(starts_at) # Ordenar por ID para consistência
    end
  end
end
