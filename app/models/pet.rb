class Pet < ApplicationRecord
  belongs_to :user
  belongs_to :species

  validates :chip_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :date_of_birth, presence: true
  validates :species, presence: true
  validates :vaccination_status, inclusion: { in: [ true, false ] }
  validates :image_link, format: { with: URI::DEFAULT_PARSER.make_regexp }, allow_blank: true
end
