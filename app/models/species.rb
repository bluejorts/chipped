class Species < ApplicationRecord
  has_many :pets
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.search(query)
    where("LOWER(name) LIKE LOWER(?)", "%#{query}%")
  end
end
