require 'time_range'

class PersonValue < ActiveRecord::Base
  VELOCITY = 50.0 / 1.hour # 50 kilometers per hour

  validates :x, presence: true
  validates :y, presence: true

  has_many :venue_person_values, dependent: :destroy

  has_many :time_ranges, as: :owner

  def time_to_venue(venue)
    Math.sqrt((x - venue.x)**2 + (y - venue.y)**2) / VELOCITY
  end

  def time_range_at_venue(venue)
    time_range = time_ranges.last
    time_to_arrive = time_to_venue(venue)
    TimeRange.new(
      from: time_range.from + time_to_arrive,
      to: time_range.to - time_to_arrive,
    )
  rescue ArgumentError
    TimeRange.new
  end

  def available_for_venue?(venue)
    venue.minimum_time <=
      time_range_at_venue(venue).intersection(venue.time_ranges.last).seconds
  end
end
