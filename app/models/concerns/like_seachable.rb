# app/models/concerns/like_searchable.rb
module LikeSearchable
  extend ActiveSupport::Concern

  included do
    scope :like, ->(field, value) {
      where("#{field} LIKE ?", "%#{value}%")
    }
  end
end
