# rubocop:disable Rails/TimeZone, Style/SingleSpaceBeforeFirstArg

require 'spec_helper'

require 'time_delta'

class Integer
  def minutes
    self * 60
  end

  def hours
    self * 60 * 60
  end

  def days
    self * 60 * 60 * 24
  end

  alias_method :minute, :minutes
  alias_method :hour, :hours
  alias_method :day, :days
end

describe TimeDelta do
  subject { TimeDelta.new(0) }

  it { respond_to :initialize_with_seconds }
  it { respond_to :initialize_with_times }

  it { respond_to :seconds }
  it { respond_to :minutes }
  it { respond_to :hours }
  it { respond_to :days }

  it { respond_to :sec }
  it { respond_to :min }
  it { respond_to :hour }

  it { respond_to :humanize }
  it { respond_to :to_s }

  describe '#initialize' do
    it 'takes number of seconds' do
      expect { TimeDelta.new(0).to_not raise_error }
    end

    it 'takes two time values' do
      expect { TimeDelta.new(Time.now, Time.now).to_not raise_error }
    end

    context 'with no arguments' do
      it 'raises ArgumentError' do
        expect { TimeDelta.new }.to raise_error ArgumentError, 'wrong number of arguments (0 for 1)'
      end
    end

    context 'with too many arguments' do
      it 'raises ArgumentError' do
        expect { TimeDelta.new(0, 0, 0) }.to raise_error ArgumentError, 'wrong number of arguments (3 for 2)'
      end
    end
  end

  describe '#seconds' do
    it 'returns the total number of seconds' do
      expect(TimeDelta.new(0).seconds).to eq 0
      expect(TimeDelta.new(60).seconds).to eq 60
      expect(TimeDelta.new(60 * 60).seconds).to eq 60 * 60
      expect(TimeDelta.new(60 * 60 * 24).seconds).to eq 60 * 60 * 24
    end
  end

  describe '#minutes' do
    it 'returns the total number of minutes' do
      expect(TimeDelta.new(0).minutes).to eq 0
      expect(TimeDelta.new(59).minutes).to eq 0
      expect(TimeDelta.new(60).minutes).to eq 1
      expect(TimeDelta.new(60 * 2 - 1).minutes).to eq 1
      expect(TimeDelta.new(60 * 2).minutes).to eq 2
      expect(TimeDelta.new(60 * 60 - 1).minutes).to eq 59
      expect(TimeDelta.new(60 * 60).minutes).to eq 60
    end
  end

  describe '#hours' do
    it 'returns the total number of hours' do
      expect(TimeDelta.new(0).hours).to eq 0
      expect(TimeDelta.new(60 * 60 - 1).hours).to eq 0
      expect(TimeDelta.new(60 * 60).hours).to eq 1
      expect(TimeDelta.new(60 * 60 * 2 - 1).hours).to eq 1
      expect(TimeDelta.new(60 * 60 * 2).hours).to eq 2
      expect(TimeDelta.new(60 * 60 * 24 - 1).hours).to eq 23
      expect(TimeDelta.new(60 * 60 * 24).hours).to eq 24
    end
  end

  describe '#days' do
    it 'returns the total number of days' do
      expect(TimeDelta.new(0).days).to eq 0
      expect(TimeDelta.new(60 * 60 * 24 - 1).days).to eq 0
      expect(TimeDelta.new(60 * 60 * 24).days).to eq 1
      expect(TimeDelta.new(60 * 60 * 24 * 2 - 1).days).to eq 1
      expect(TimeDelta.new(60 * 60 * 24 * 2).days).to eq 2
    end
  end

  describe '#sec' do
    it 'returns seconds remainder' do
      expect(TimeDelta.new(0).sec).to eq 0
      expect(TimeDelta.new(60 - 1).sec).to eq 59
      expect(TimeDelta.new(60).sec).to eq 0
      expect(TimeDelta.new(60 * 2 - 1).sec).to eq 59
      expect(TimeDelta.new(60 * 2).sec).to eq 0
    end
  end

  describe '#min' do
    it 'returns minutes remainder' do
      expect(TimeDelta.new(0).min).to eq 0
      expect(TimeDelta.new(59).min).to eq 0
      expect(TimeDelta.new(60).min).to eq 1
      expect(TimeDelta.new(60 * 2 - 1).min).to eq 1
      expect(TimeDelta.new(60 * 2).min).to eq 2
      expect(TimeDelta.new(60 * 60 - 1).min).to eq 59
      expect(TimeDelta.new(60 * 60).min).to eq 0
      expect(TimeDelta.new(60 * 60 * 2 - 1).min).to eq 59
      expect(TimeDelta.new(60 * 60 * 2).min).to eq 0
    end
  end

  describe '#hour' do
    it 'returns hours remainder' do
      expect(TimeDelta.new(0).hour).to eq 0
      expect(TimeDelta.new(60 * 60 - 1).hour).to eq 0
      expect(TimeDelta.new(60 * 60).hour).to eq 1
      expect(TimeDelta.new(60 * 60 * 2 - 1).hour).to eq 1
      expect(TimeDelta.new(60 * 60 * 2).hour).to eq 2
      expect(TimeDelta.new(60 * 60 * 24 - 1).hour).to eq 23
      expect(TimeDelta.new(60 * 60 * 24).hour).to eq 0
      expect(TimeDelta.new(60 * 60 * 24 * 2 - 1).hour).to eq 23
      expect(TimeDelta.new(60 * 60 * 24 * 2).hour).to eq 0
    end
  end

  describe '#humanize' do
    context 'without arguments' do
      it 'returns the full string' do
        expect(TimeDelta.new(0).humanize).to                   eq '0 days 0 hours 0 minutes 0 seconds'
        expect(TimeDelta.new(1).humanize).to                   eq '0 days 0 hours 0 minutes 1 second'
        (2..59).each do |n|
          expect(TimeDelta.new(n).humanize).to                 eq "0 days 0 hours 0 minutes #{n} seconds"
        end
        expect(TimeDelta.new(1.minute).humanize).to            eq '0 days 0 hours 1 minute 0 seconds'
        expect(TimeDelta.new(1.minute + 1).humanize).to        eq '0 days 0 hours 1 minute 1 second'
        expect(TimeDelta.new(1.minute + 2).humanize).to        eq '0 days 0 hours 1 minute 2 seconds'
        (2..59).each do |n|
          expect(TimeDelta.new(n.minutes).humanize).to         eq "0 days 0 hours #{n} minutes 0 seconds"
        end
        expect(TimeDelta.new(2.minutes + 1).humanize).to       eq '0 days 0 hours 2 minutes 1 second'
        expect(TimeDelta.new(2.minutes + 2).humanize).to       eq '0 days 0 hours 2 minutes 2 seconds'
        expect(TimeDelta.new(1.hour).humanize).to              eq '0 days 1 hour 0 minutes 0 seconds'
        expect(TimeDelta.new(1.hour + 1.minute).humanize).to   eq '0 days 1 hour 1 minute 0 seconds'
        expect(TimeDelta.new(1.hour + 2.minutes).humanize).to  eq '0 days 1 hour 2 minutes 0 seconds'
        (2..23).each do |n|
          expect(TimeDelta.new(n.hours).humanize).to           eq "0 days #{n} hours 0 minutes 0 seconds"
        end
        expect(TimeDelta.new(2.hours + 1.minute).humanize).to  eq '0 days 2 hours 1 minute 0 seconds'
        expect(TimeDelta.new(2.hours + 2.minutes).humanize).to eq '0 days 2 hours 2 minutes 0 seconds'
        expect(TimeDelta.new(1.day).humanize).to               eq '1 day 0 hours 0 minutes 0 seconds'
        expect(TimeDelta.new(1.day + 1.hour).humanize).to      eq '1 day 1 hour 0 minutes 0 seconds'
        expect(TimeDelta.new(1.day + 2.hours).humanize).to     eq '1 day 2 hours 0 minutes 0 seconds'
        expect(TimeDelta.new(2.days).humanize).to              eq '2 days 0 hours 0 minutes 0 seconds'
        expect(TimeDelta.new(2.days + 1.hour).humanize).to     eq '2 days 1 hour 0 minutes 0 seconds'
        expect(TimeDelta.new(2.days + 2.hours).humanize).to    eq '2 days 2 hours 0 minutes 0 seconds'
      end
    end

    context 'when option ":only"' do
      context 'equals ":seconds"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(only: :seconds))
            .to eq '0 seconds'
          expect(TimeDelta.new(1).humanize(only: :seconds))
            .to eq '1 second'
          expect(TimeDelta.new(2).humanize(only: :seconds))
            .to eq '2 seconds'
          expect(TimeDelta.new(59).humanize(only: :seconds))
            .to eq '59 seconds'
          expect(TimeDelta.new(60).humanize(only: :seconds))
            .to eq '60 seconds'
          expect(TimeDelta.new(61).humanize(only: :seconds))
            .to eq '61 seconds'
        end
      end

      context 'equals ":minutes"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(only: :minutes))
            .to eq '0 minutes'
          expect(TimeDelta.new(1.minute - 1).humanize(only: :minutes))
            .to eq '0 minutes'
          expect(TimeDelta.new(1.minute).humanize(only: :minutes))
            .to eq '1 minute'
          expect(TimeDelta.new(2.minutes - 1).humanize(only: :minutes))
            .to eq '1 minute'
          expect(TimeDelta.new(2.minutes).humanize(only: :minutes))
            .to eq '2 minutes'
          expect(TimeDelta.new(60.minutes - 1).humanize(only: :minutes))
            .to eq '59 minutes'
          expect(TimeDelta.new(60.minutes).humanize(only: :minutes))
            .to eq '60 minutes'
          expect(TimeDelta.new(61.minutes).humanize(only: :minutes))
            .to eq '61 minutes'
        end
      end

      context 'equals ":hours"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(only: :hours))
            .to eq '0 hours'
          expect(TimeDelta.new(1.hour - 1).humanize(only: :hours))
            .to eq '0 hours'
          expect(TimeDelta.new(1.hour).humanize(only: :hours))
            .to eq '1 hour'
          expect(TimeDelta.new(2.hours - 1).humanize(only: :hours))
            .to eq '1 hour'
          expect(TimeDelta.new(2.hours).humanize(only: :hours))
            .to eq '2 hours'
          expect(TimeDelta.new(24.hours - 1).humanize(only: :hours))
            .to eq '23 hours'
          expect(TimeDelta.new(24.hours).humanize(only: :hours))
            .to eq '24 hours'
          expect(TimeDelta.new(25.hours).humanize(only: :hours))
            .to eq '25 hours'
        end
      end

      context 'equals ":days"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(only: :days))
            .to eq '0 days'
          expect(TimeDelta.new(1.day - 1).humanize(only: :days))
            .to eq '0 days'
          expect(TimeDelta.new(1.day).humanize(only: :days))
            .to eq '1 day'
          expect(TimeDelta.new(2.days - 1).humanize(only: :days))
            .to eq '1 day'
          expect(TimeDelta.new(2.days).humanize(only: :days))
            .to eq '2 days'
        end
      end
    end

    context 'when lower value' do
      context 'equals ":seconds"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(lower: :seconds))
            .to eq '0 days 0 hours 0 minutes 0 seconds'
        end
      end

      context 'equals ":minutes"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(lower: :minutes))
            .to eq '0 days 0 hours 0 minutes'
        end
      end

      context 'equals ":hours"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(lower: :hours))
            .to eq '0 days 0 hours'
        end
      end

      context 'equals ":days"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(lower: :days))
            .to eq '0 days'
        end
      end
    end

    context 'when top value' do
      context 'equals ":seconds"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(top: :seconds))
            .to eq '0 seconds'
        end
      end

      context 'equals ":minutes"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(top: :minutes))
            .to eq '0 minutes 0 seconds'
        end
      end

      context 'equals ":hours"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(top: :hours))
            .to eq '0 hours 0 minutes 0 seconds'
        end
      end

      context 'equals ":days"' do
        it 'returns the correct string' do
          expect(TimeDelta.new(0).humanize(top: :days))
            .to eq '0 days 0 hours 0 minutes 0 seconds'
        end
      end
    end

    context 'when lower and top values are provided' do
      it 'returns the correct string' do
        expect(TimeDelta.new(0).humanize(lower: :seconds, top: :seconds))
          .to eq '0 seconds'
        expect(TimeDelta.new(0).humanize(lower: :seconds, top: :minutes))
          .to eq '0 minutes 0 seconds'
        expect(TimeDelta.new(0).humanize(lower: :seconds, top: :hours))
          .to eq '0 hours 0 minutes 0 seconds'
        expect(TimeDelta.new(0).humanize(lower: :seconds, top: :days))
          .to eq '0 days 0 hours 0 minutes 0 seconds'
        expect(TimeDelta.new(0).humanize(lower: :minutes, top: :minutes))
          .to eq '0 minutes'
        expect(TimeDelta.new(0).humanize(lower: :minutes, top: :hours))
          .to eq '0 hours 0 minutes'
        expect(TimeDelta.new(0).humanize(lower: :minutes, top: :days))
          .to eq '0 days 0 hours 0 minutes'
        expect(TimeDelta.new(0).humanize(lower: :hours, top: :hours))
          .to eq '0 hours'
        expect(TimeDelta.new(0).humanize(lower: :hours, top: :days))
          .to eq '0 days 0 hours'
        expect(TimeDelta.new(0).humanize(lower: :days, top: :days))
          .to eq '0 days'
      end

      context 'and lower value is greater than top value' do
        it 'raises ArgumentError' do
          expect { TimeDelta.new(0).humanize(lower: :minutes, top: :seconds) }
            .to raise_error ArgumentError, 'lower value is greater than top value'
          expect { TimeDelta.new(0).humanize(lower: :hours, top: :seconds) }
            .to raise_error ArgumentError, 'lower value is greater than top value'
          expect { TimeDelta.new(0).humanize(lower: :hours, top: :minutes) }
            .to raise_error ArgumentError, 'lower value is greater than top value'
          expect { TimeDelta.new(0).humanize(lower: :days, top: :seconds) }
            .to raise_error ArgumentError, 'lower value is greater than top value'
          expect { TimeDelta.new(0).humanize(lower: :days, top: :minutes) }
            .to raise_error ArgumentError, 'lower value is greater than top value'
          expect { TimeDelta.new(0).humanize(lower: :days, top: :hours) }
            .to raise_error ArgumentError, 'lower value is greater than top value'
        end
      end
    end
  end
end
