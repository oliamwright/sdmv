# rubocop:disable Rails/TimeZone

require 'spec_helper'

require 'time_range'

TIME = Time.now

describe TimeRange do # << TimeDelta
  subject { TimeRange.new(Time.now, Time.now) }

  it { respond_to :empty? }

  it { respond_to :== }
  it { respond_to :eql? }

  it { respond_to :& }
  it { respond_to :intersection }

  it { respond_to :include? }

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

  describe '#empty?' do
    it 'returns true for empty time range' do
      expect(TimeRange.new.empty?).to be true
      expect(TimeRange.new(TIME, TIME).empty?).to be true
    end

    it 'returns false for non-empty time range' do
      expect(TimeRange.new(TIME, TIME + 1).empty?).to be false
    end
  end

  describe '#==' do
    it 'returns true for two empty time ranges' do
      expect(TimeRange.new == TimeRange.new(TIME, TIME)).to be true
    end

    it 'returns true for two equal time ranges' do
      range_1 = TimeRange.new(TIME, TIME + 1)
      range_2 = TimeRange.new(TIME, TIME + 1)
      expect(range_1 == range_2).to be true
    end

    it 'returns false for two non-equal time ranges' do
      range_1 = TimeRange.new(TIME + 1, TIME + 2)
      range_2 = TimeRange.new(TIME + 1, TIME + 3)
      expect(range_1 == range_2).to be false
      expect(range_1 == TimeRange.new).to be false
    end
  end

  describe '#&' do
    it 'returns intersection of two intersecting time ranges' do
      range_1 = TimeRange.new(TIME, TIME + 1000)
      range_2 = TimeRange.new(TIME + 250, TIME + 1105)
      expect(range_1 & range_2).to eq TimeRange.new(TIME + 250, TIME + 1000)
    end

    it 'returns empty time range for two non-intersecting time ranges' do
      range_1 = TimeRange.new(TIME, TIME + 305)
      range_2 = TimeRange.new(TIME + 310, TIME + 701)
      expect(range_1 & range_2).to eq TimeRange.new
    end
  end

  describe '#include?' do
    it 'returns false for empty time range and any given object' do
      range = TimeRange.new
      expect(range.include?(range.from)).to be false
      expect(range.include?(range.to)).to be false
    end

    it 'returns false if time range doesn\'t include given time' do
      range = TimeRange.new(TIME, TIME + 1)
      expect(range.include?(TIME - 1)).to be false
      expect(range.include?(TIME + 1)).to be false
    end

    it 'returns true if time range includes given time' do
      range = TimeRange.new(TIME, TIME + 2)
      expect(range.include?(TIME)).to be true
      expect(range.include?(TIME + 1)).to be true
    end
  end
end
