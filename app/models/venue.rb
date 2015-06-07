require 'time_range'

class Venue < ActiveRecord::Base
  validates :x, presence: true
  validates :y, presence: true

  has_many :venue_person_values, dependent: :destroy
  has_many :time_ranges, as: :owner

  def self.by_val
  	Venue.order(sum_value: :desc).includes(:venue_person_values)
  end
  
end
