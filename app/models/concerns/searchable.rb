module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search, ->(query) {
      columns_to_search = %w[key platform] # Altere para as colunas desejadas
      where(
        columns_to_search.map { |column| "LOWER(#{column}) LIKE :query" }.join(' OR '),
        query: "%#{query.downcase}%"
      )
    }
  end
end
