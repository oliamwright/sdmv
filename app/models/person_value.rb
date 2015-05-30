require 'time_range'

class PersonValue < ActiveRecord::Base
  VELOCITY = 50.0 / 1.hour # 50 kilometers per hour
  MINIMUM_TIME_AT_VENUE = 30.minutes

  validates :x, presence: true
  validates :y, presence: true

  has_many :venue_person_values, dependent: :destroy

  def time_range
    TimeRange.new(from, to)
  end

  def time_to_venue(venue)
    Math.sqrt((x - venue.x)**2 + (y - venue.y)**2) / VELOCITY
  end

  def time_range_at_venue(venue)
    time_to_arrive = time_to_venue(venue)
    TimeRange.new(from + time_to_arrive, to - time_to_arrive)
  rescue ArgumentError
    TimeRange.new
  end

  def available_for_venue?(venue)
    MINIMUM_TIME_AT_VENUE <=
      time_range_at_venue(venue).intersection(venue.time_range).seconds
  end
end
