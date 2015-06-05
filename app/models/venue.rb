require 'time_range'

class Venue < ActiveRecord::Base
  validates :x, presence: true
  validates :y, presence: true

  has_many :venue_person_values, dependent: :destroy

  def self.by_val
  	Venue.order(sum_value: :desc).includes(:venue_person_values)
  end

  def time_range
    TimeRange.new(from, to)
  end
end
