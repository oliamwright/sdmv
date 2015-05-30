require 'time_range'

class PersonValue < ActiveRecord::Base
  validates :x, presence: true
  validates :y, presence: true

  has_many :venue_person_values, dependent: :destroy

  def time_range
    TimeRange.new(from, to)
  end
end
