require 'spec_helper'

require 'time_delta'

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
    it 'takes number of seconds'

    it 'takes two time values'

    context 'with no arguments' do
      it 'raises ArgumentError'
    end

    context 'with too many arguments' do
      it 'raises ArgumentError'
    end
  end

  describe '#seconds' do
    it 'returns the total number of seconds'
  end

  describe '#minutes' do
    it 'returns the total number of minutes'
  end

  describe '#hours' do
    it 'returns the total number of hours'
  end

  describe '#days' do
    it 'returns the total number of days'
  end

  describe '#sec' do
    it 'returns seconds remainder'
  end

  describe '#min' do
    it 'returns minutes remainder'
  end

  describe '#hour' do
    it 'returns hours remainder'
  end

  describe '#humanize' do
    context 'without arguments' do
      it 'returns the full string'
    end

    context 'when option ":only"' do
      context 'equals ":seconds"' do
        it 'returns the correct string'
      end

      context 'equals ":minutes"' do
        it 'returns the correct string'
      end

      context 'equals ":hours"' do
        it 'returns the correct string'
      end

      context 'equals ":days"' do
        it 'returns the correct string'
      end
    end

    context 'when lower value' do
      context 'equals ":seconds"' do
        it 'returns the correct string'
      end

      context 'equals ":minutes"' do
        it 'returns the correct string'
      end

      context 'equals ":hours"' do
        it 'returns the correct string'
      end

      context 'equals ":days"' do
        it 'returns the correct string'
      end
    end

    context 'when top value' do
      context 'equals ":seconds"' do
        it 'returns the correct string'
      end

      context 'equals ":minutes"' do
        it 'returns the correct string'
      end

      context 'equals ":hours"' do
        it 'returns the correct string'
      end

      context 'equals ":days"' do
        it 'returns the correct string'
      end
    end

    context 'when lower and top values are provided' do
      it 'returns the correct string'

      context 'and lower value is greater than top value' do
        it 'raises ArgumentError'
      end
    end
  end
end
