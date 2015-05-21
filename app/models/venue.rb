class Venue < ActiveRecord::Base
  validates :x, presence: true
  validates :y, presence: true

  has_many :venue_person_values, dependent: :destroy
end