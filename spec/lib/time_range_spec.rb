require 'spec_helper'

require 'time_range'

describe TimeRange do # << TimeDelta
  subject { TimeRange.new(Time.now, Time.now) }

  describe '#initialize' do
    it 'takes two time values'
  end

  describe '#to_s' do
    it 'provides options to TimeDelta#humanize'

    context 'when start and end time' do
      context 'are the same date' do
        it 'returns the correct string'
      end

      context 'are different dates' do
        it 'returns the correct string'
      end
    end
  end
end
