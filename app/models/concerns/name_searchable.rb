module NameSearchable
  extend ActiveSupport::Concern

  included do
    scope :search_by_name, -> (value) do
      return all if value.blank?

      self.where("LOWER(name) LIKE ?", "%#{value.downcase}%")
    end
  end
end