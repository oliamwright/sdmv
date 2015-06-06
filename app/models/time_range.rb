##
# Polymorphic time range
#
class TimeRange < ActiveRecord::Base
  NIL_TIME = Time.new(0) # rubocop:disable Rails/TimeZone

  belongs_to :owner, polymorphic: true

  validates :from,
            presence: true

  validates :to,
            presence: true

  def initialize(options = {})
    super(options)

    if from.nil? && to.nil?
      self.from = NIL_TIME
      self.to = NIL_TIME
    end

    fail ArgumentError unless from && to

    from <= to or
      fail ArgumentError, 'start of time range should be less then end'
  end

  def seconds
    @seconds = (to - from).to_i
  end

  def minutes
    @minutes ||= seconds / 60
  end

  def hours
    @hours ||= minutes / 60
  end

  def days
    @days ||= hours / 24
  end

  def sec
    @sec ||= seconds % 60
  end

  def min
    @min ||= minutes % 60
  end

  def hour
    @hour ||= hours % 24
  end

  def empty?
    from == to
  end

  def ==(other)
    from == other.from && to == other.to || empty? && other.empty?
  end

  alias_method :eql?, :==

  def &(other)
    TimeRange.new(
      from: [from, other.from].max,
      to: [to, other.to].min,
    )
  rescue ArgumentError
    TimeRange.new
  end

  alias_method :intersection, :&

  def include?(time)
    from <= time && time < to
  end

  def to_s(options = {})
    date = from.to_date
    if date == to.to_date
      "#{humanize options} (#{date} \
from #{TimeRange.format_time from} to #{TimeRange.format_time to})"
    else
      "#{humanize options} (\
from #{TimeRange.format_datetime from} to #{TimeRange.format_datetime to})"
    end
  end

  def self.format_time(time)
    time.strftime('%H:%M')
  end

  def self.format_datetime(time)
    time.strftime('%Y-%m-%d %H:%M')
  end

  VARIANTS = [:seconds, :minutes, :hours, :days]

  def humanize(options = {})
    lower = VARIANTS.index(options[:only] || options[:lower] || VARIANTS.first)
    top = VARIANTS.index(options[:only] || options[:top] || VARIANTS.last)

    unless lower <= top
      fail ArgumentError, 'lower value is greater than top value'
    end

    s = ''

    s << "#{days} day#{'s' if days != 1}" if top == 3

    if lower <= 2 && 2 <= top
      hours = top == 2 ? self.hours : hour
      s << "#{' ' unless s.empty?}#{hours} hour#{'s' if hours != 1}"
    end

    if lower <= 1 && 1 <= top
      minutes = top == 1 ? self.minutes : min
      s << "#{' ' unless s.empty?}#{minutes} minute#{'s' if minutes != 1}"
    end

    if lower == 0
      seconds = top == 0 ? self.seconds : sec
      s << "#{' ' unless s.empty?}#{seconds} second#{'s' if seconds != 1}"
    end

    s
  end
end
