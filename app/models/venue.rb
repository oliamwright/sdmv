class Venue < ActiveRecord::Base
  validates :x, presence: true
  validates :y, presence: true
end