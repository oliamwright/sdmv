# rubocop:disable Rails/TimeZone

require 'rails_helper'

describe TimeRange, type: :model do
  let(:time) { Time.now.at_beginning_of_day }

  subject { TimeRange.new(from: time, to: time) }

  it { should be_valid }

  it { should respond_to :owner }

  it { should respond_to :from }
  it { should respond_to :to }

  it { should respond_to :seconds }
  it { should respond_to :minutes }
  it { should respond_to :hours }
  it { should respond_to :days }

  it { should respond_to :sec }
  it { should respond_to :min }
  it { should respond_to :hour }

  it { should respond_to :empty? }

  it { should respond_to :== }
  it { should respond_to :eql? }

  it { should respond_to :& }
  it { should respond_to :intersection }

  it { should respond_to :include? }

  it { should respond_to :to_s }
  it { should respond_to :humanize }

  it '#from <= #to' do
    expect { TimeRange.new(from: time, to: time - 100) }.to raise_error ArgumentError
  end

  describe '#from' do
    it 'exists' do
      expect { TimeRange.new(to: time) }.to raise_error ArgumentError
    end
  end

  describe '#to' do
    it 'exists' do
      expect { TimeRange.new(from: time) }.to raise_error ArgumentError
    end
  end

  describe '#seconds' do
    it 'returns the total number of seconds' do
      expect(TimeRange.new(from: time, to: time).seconds).to eq 0
      expect(TimeRange.new(from: time, to: time + 60).seconds).to eq 60
      expect(TimeRange.new(from: time, to: time + 60 * 60).seconds).to eq 60 * 60
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24).seconds).to eq 60 * 60 * 24
    end
  end

  describe '#minutes' do
    it 'returns the total number of minutes' do
      expect(TimeRange.new(from: time, to: time + 0).minutes).to eq 0
      expect(TimeRange.new(from: time, to: time + 59).minutes).to eq 0
      expect(TimeRange.new(from: time, to: time + 60).minutes).to eq 1
      expect(TimeRange.new(from: time, to: time + 60 * 2 - 1).minutes).to eq 1
      expect(TimeRange.new(from: time, to: time + 60 * 2).minutes).to eq 2
      expect(TimeRange.new(from: time, to: time + 60 * 60 - 1).minutes).to eq 59
      expect(TimeRange.new(from: time, to: time + 60 * 60).minutes).to eq 60
    end
  end

  describe '#hours' do
    it 'returns the total number of hours' do
      expect(TimeRange.new(from: time, to: time + 0).hours).to eq 0
      expect(TimeRange.new(from: time, to: time + 60 * 60 - 1).hours).to eq 0
      expect(TimeRange.new(from: time, to: time + 60 * 60).hours).to eq 1
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 2 - 1).hours).to eq 1
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 2).hours).to eq 2
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24 - 1).hours).to eq 23
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24).hours).to eq 24
    end
  end

  describe '#days' do
    it 'returns the total number of days' do
      expect(TimeRange.new(from: time, to: time + 0).days).to eq 0
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24 - 1).days).to eq 0
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24).days).to eq 1
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24 * 2 - 1).days).to eq 1
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24 * 2).days).to eq 2
    end
  end

  describe '#sec' do
    it 'returns seconds remainder' do
      expect(TimeRange.new(from: time, to: time + 0).sec).to eq 0
      expect(TimeRange.new(from: time, to: time + 60 - 1).sec).to eq 59
      expect(TimeRange.new(from: time, to: time + 60).sec).to eq 0
      expect(TimeRange.new(from: time, to: time + 60 * 2 - 1).sec).to eq 59
      expect(TimeRange.new(from: time, to: time + 60 * 2).sec).to eq 0
    end
  end

  describe '#min' do
    it 'returns minutes remainder' do
      expect(TimeRange.new(from: time, to: time + 0).min).to eq 0
      expect(TimeRange.new(from: time, to: time + 59).min).to eq 0
      expect(TimeRange.new(from: time, to: time + 60).min).to eq 1
      expect(TimeRange.new(from: time, to: time + 60 * 2 - 1).min).to eq 1
      expect(TimeRange.new(from: time, to: time + 60 * 2).min).to eq 2
      expect(TimeRange.new(from: time, to: time + 60 * 60 - 1).min).to eq 59
      expect(TimeRange.new(from: time, to: time + 60 * 60).min).to eq 0
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 2 - 1).min).to eq 59
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 2).min).to eq 0
    end
  end

  describe '#hour' do
    it 'returns hours remainder' do
      expect(TimeRange.new(from: time, to: time + 0).hour).to eq 0
      expect(TimeRange.new(from: time, to: time + 60 * 60 - 1).hour).to eq 0
      expect(TimeRange.new(from: time, to: time + 60 * 60).hour).to eq 1
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 2 - 1).hour).to eq 1
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 2).hour).to eq 2
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24 - 1).hour).to eq 23
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24).hour).to eq 0
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24 * 2 - 1).hour).to eq 23
      expect(TimeRange.new(from: time, to: time + 60 * 60 * 24 * 2).hour).to eq 0
    end
  end

  describe '#empty?' do
    it 'returns true for empty time range' do
      expect(TimeRange.new.empty?).to be true
      expect(TimeRange.new(from: time, to: time).empty?).to be true
    end

    it 'returns false for non-empty time range' do
      expect(TimeRange.new(from: time, to: time + 1).empty?).to be false
    end
  end

  describe '#==' do
    it 'returns true for two empty time ranges' do
      expect(TimeRange.new == TimeRange.new(from: time, to: time)).to be true
    end

    it 'returns true for two equal time ranges' do
      range_1 = TimeRange.new(from: time, to: time + 1)
      range_2 = TimeRange.new(from: time, to: time + 1)
      expect(range_1 == range_2).to be true
    end

    it 'returns false for two non-equal time ranges' do
      range_1 = TimeRange.new(from: time + 1, to: time + 2)
      range_2 = TimeRange.new(from: time + 1, to: time + 3)
      expect(range_1 == range_2).to be false
      expect(range_1 == TimeRange.new).to be false
    end
  end

  describe '#&' do
    it 'returns intersection of two intersecting time ranges' do
      range_1 = TimeRange.new(from: time, to: time + 1000)
      range_2 = TimeRange.new(from: time + 250, to: time + 1105)
      expect(range_1 & range_2)
        .to eq TimeRange.new(from: time + 250, to: time + 1000)
    end

    it 'returns empty time range for two non-intersecting time ranges' do
      range_1 = TimeRange.new(from: time, to: time + 305)
      range_2 = TimeRange.new(from: time + 310, to: time + 701)
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
      range = TimeRange.new(from: time, to: time + 1)
      expect(range.include?(time - 1)).to be false
      expect(range.include?(time + 1)).to be false
    end

    it 'returns true if time range includes given time' do
      range = TimeRange.new(from: time, to: time + 2)
      expect(range.include?(time)).to be true
      expect(range.include?(time + 1)).to be true
    end
  end

  describe '#to_s' do
    it 'provides options to #humanize' do
      expect(TimeRange.new(from: time, to: time + 61).to_s(only: :seconds))
        .to start_with '61 seconds'
      expect(TimeRange.new(from: time, to: time + 12.hours).to_s(lower: :hours))
        .to start_with '0 days 12 hours'
      expect(
        TimeRange.new(from: time, to: time + 61.minutes).to_s(top: :minutes)
      ).to start_with '61 minutes 0 seconds'
    end

    context 'when start and end time' do
      context 'are the same date' do
        it 'returns the correct string' do
          expect(TimeRange.new(from: time, to: time + 1.hour).to_s)
            .to match /\(\d{4}-\d\d-\d\d from \d\d:\d\d to \d\d:\d\d\)$/
        end
      end

      context 'are different dates' do
        it 'returns the correct string' do
          expect(
            TimeRange.new(from: time, to: time + 1.day + 1.hour).to_s
          ).to match(
            /\(from \d{4}-\d\d-\d\d \d\d:\d\d to \d{4}-\d\d-\d\d \d\d:\d\d\)$/
          )
        end
      end
    end
  end
end
