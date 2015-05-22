require 'time_delta'

class TimeRange < TimeDelta
  NIL_TIME = Time.new(0)

  attr_reader :from, :to

  def initialize(from = NIL_TIME, to = NIL_TIME)
    from.is_a? Time and to.is_a? Time or
      fail ArgumentError, 'arguments\' type should be Time'

    from <= to or
      fail ArgumentError, 'start of time range should be less then end'

    @from = from
    @to = to

    initialize_with_times(@from, @to)
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

  def empty?
    from == to
  end

  def ==(other)
    from == other.from && to == other.to || empty? && other.empty?
  end

  alias_method :eql?, :==

  def &(other)
    TimeRange.new(
      [from, other.from].max,
      [to, other.to].min,
    )
  rescue ArgumentError
    TimeRange.new
  end

  alias_method :intersection, :&

  def include?(time)
    from <= time && time < to
  end

  def self.format_time(time)
    time.strftime('%H:%M')
  end

  def self.format_datetime(time)
    time.strftime('%Y-%m-%d %H:%M')
  end
end
