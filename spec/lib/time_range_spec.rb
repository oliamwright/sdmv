# rubocop:disable Rails/TimeZone

require 'spec_helper'

require 'time_range'

TIME = Time.now

describe TimeRange do # << TimeDelta
  subject { TimeRange.new(Time.now, Time.now) }

  describe '#initialize' do
    it 'takes two time values' do
      expect { TimeRange.new(Time.now, Time.now) }.to_not raise_error
      expect { TimeRange.new(0, Time.now) }
        .to raise_error ArgumentError, 'arguments\' type should be Time'
      expect { TimeRange.new(Time.now, 0) }
        .to raise_error ArgumentError, 'arguments\' type should be Time'
      expect { TimeRange.new(Time.now, Time.now - 100) }
        .to raise_error ArgumentError,
                        'start of time range should be less then end'
    end
  end

  describe '#to_s' do
    it 'provides options to TimeDelta#humanize' do
      expect(TimeRange.new(TIME, TIME + 61).to_s(only: :seconds))
        .to start_with '61 seconds'
      expect(TimeRange.new(TIME, TIME + 12.hours).to_s(lower: :hours))
        .to start_with '0 days 12 hours'
      expect(TimeRange.new(TIME, TIME + 61.minutes).to_s(top: :minutes))
        .to start_with '61 minutes 0 seconds'
    end

    context 'when start and end time' do
      context 'are the same date' do
        it 'returns the correct string' do
          time = Time.parse('0000-01-01 00:00')
          expect(TimeRange.new(time, time + 1.hour).to_s)
            .to match /\(\d{4}-\d\d-\d\d from \d\d:\d\d to \d\d:\d\d\)$/
        end
      end

      context 'are different dates' do
        it 'returns the correct string' do
          time = Time.parse('0000-01-01 00:00')
          expect(TimeRange.new(time, time + 1.day + 1.hour).to_s).to match(
            /\(from \d{4}-\d\d-\d\d \d\d:\d\d to \d{4}-\d\d-\d\d \d\d:\d\d\)$/
          )
        end
      end
    end
  end
end
