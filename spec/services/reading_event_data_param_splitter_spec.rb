require 'spec_helper'

describe 'Reading Event data param splitter', type: :unit do
  let(:subject) { ReadingEventDataParamSplitter }

  describe 'With data for one sensor event' do
    it 'should return event fields in a hash within an array' do
      result = subject.new('3|123.12|321.12').process

      expect(result.first).to(
        eq(sensor_id: '3', first_read: '123.12', second_read: '321.12')
      )
    end
  end

  describe 'With data for two sensor events' do
    it 'should return each event fields in a hash within an array' do
      result = subject.new('0|123.12|321.12|-1|444.44|333.33').process

      expected_result = [
        { sensor_id: '0', first_read: '123.12', second_read: '321.12' },
        { sensor_id: '1', first_read: '444.44', second_read: '333.33' }
      ]

      expect(result).to eq expected_result
    end
  end

  describe 'With data for three sensor events' do
    it 'should return each event fields in a hash within an array' do
      result = subject.new('0|123.12|321.12|-1|444.44|333.33|-2|1|2').process

      expected_result = [
        { sensor_id: '0', first_read: '123.12', second_read: '321.12' },
        { sensor_id: '1', first_read: '444.44', second_read: '333.33' },
        { sensor_id: '2', first_read: '1', second_read: '2' }
      ]

      expect(result).to eq expected_result
    end
  end

  describe 'With data for four sensor events' do
    it 'should return each event fields in a hash within an array' do
      result =
        subject.new('0|123.12|321.12|-1|444.44|333.33|-2|1|2|-3|9|0').process

      expected_result = [
        { sensor_id: '0', first_read: '123.12', second_read: '321.12' },
        { sensor_id: '1', first_read: '444.44', second_read: '333.33' },
        { sensor_id: '2', first_read: '1', second_read: '2' },
        { sensor_id: '3', first_read: '9', second_read: '0' }
      ]

      expect(result).to eq expected_result
    end
  end

  describe 'Format validation' do
    describe 'for one event' do
      it 'valid if right format' do
        expect(subject.new('1|1|1').validate_format).to eq true
      end

      it 'invalid if missing field' do
        expect(subject.new('1|1').validate_format).to eq false
      end
    end

    describe 'for several events' do
      it 'valid if right format' do
        expect(subject.new('1|1|1-2|2|2').validate_format).to eq true
      end

      it 'invalid if missing field in any event' do
        expect(subject.new('1|1|1-2|3').validate_format).to eq false
      end

      it 'invalid if ends with a |' do
        expect(subject.new('1|1|1-2|3|').validate_format).to eq false
      end
    end
  end
end
