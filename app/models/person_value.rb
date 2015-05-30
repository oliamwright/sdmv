require 'time_range'

class PersonValue < ActiveRecord::Base
  VELOCITY = 50.0 / 1.hour # 50 kilometers per hour

  validates :x, presence: true
  validates :y, presence: true

  has_many :venue_person_values, dependent: :destroy

  def time_range
    TimeRange.new(from, to)
  end

  def time_to_venue(venue)
    Math.sqrt((x - venue.x)**2 + (y - venue.y)**2) / VELOCITY
  end
end
