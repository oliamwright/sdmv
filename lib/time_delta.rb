class TimeDelta
  def initialize(*args)
    if args.length < 2
      initialize_with_seconds(*args)
    else
      initialize_with_times(*args)
    end
  end

  protected

  def initialize_with_seconds(seconds)
    @seconds = seconds.to_i
  end

  def initialize_with_times(from, to)
    @seconds = (to - from).to_i
  end

  public

  attr_reader :seconds

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

  VARIANTS = [:seconds, :minutes, :hours, :days]

  def humanize(options = {})
    lower = VARIANTS.index(options[:only] || options[:lower] || :seconds)
    top   = VARIANTS.index(options[:only] || options[:top] || :days)

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

  alias_method :to_s, :humanize
end
