class License < ApplicationRecord
  include Paginatable

  belongs_to :game, required: true

  validates :key, presence: true, uniqueness: { case_sensitive: false, scope: :platform }
  validates :status, presence: true
  validates :platform, presence: true

  enum platform: { steam: 1, battle_net: 2, origin: 3 }
  enum status: { available: 1, in_use: 2, inactive: 3 }

  def self.search(query)
    where('LOWER(key) LIKE :query OR LOWER(platform) LIKE :query', query: "%#{query.downcase}%")
  end
end
