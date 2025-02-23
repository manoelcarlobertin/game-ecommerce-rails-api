class Game < ApplicationRecord
  include Searchable

  has_many :licenses, dependent: :destroy
  belongs_to :system_requirement
  has_one :product, as: :productable

  validates :mode, presence: true
  validates :release_date, presence: true
  validates :developer, presence: true

  enum mode: { pvp: 1, pve: 2, both: 3 }

    def self.search(query)
      where("name LIKE ?", "%#{query}%")
    end
end


