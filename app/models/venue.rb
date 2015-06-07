require 'time_range'

class Venue < ActiveRecord::Base
  validates :x, presence: true
  validates :y, presence: true

  has_many :venue_person_values, dependent: :destroy

  has_many :time_ranges, as: :owner

  def time_range
    TimeRange.new(from, to)
  end
end
