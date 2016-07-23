require 'spec_helper'

describe 'Reading Events Creator' do
  describe 'with an existant device_id and one sensor event' do
    it 'should create one ReadingEvent' do
      device = Device.create(particle_id: 'SAD')
      sensor_data = 'd-3|123|321'

      factory = ReadingEventsCreator.new(device, sensor_data)
      factory.create_reading_events

      expect(ReadingEvent.count).to eq 1
      reading_event = ReadingEvent.last
      expect(reading_event.sensor_id).to eq 3
      expect(reading_event.start_read).to eq 123
      expect(reading_event.end_read).to eq 321
      expect(reading_event.read_difference).to eq 198
    end
  end

  describe 'with an existant device_id and two sensor events' do
    it 'should create two ReadingEvents' do
      device = Device.create(particle_id: 'SAD')
      sensor_data = 'd-3|123|321|-2|100|99'

      factory = ReadingEventsCreator.new(device, sensor_data)
      factory.create_reading_events

      expect(ReadingEvent.count).to eq 2
      reading_event_1 = ReadingEvent.first
      expect(reading_event_1.sensor_id).to eq 3
      expect(reading_event_1.start_read).to eq 123
      expect(reading_event_1.end_read).to eq 321
      expect(reading_event_1.read_difference).to eq 198

      reading_event_2 = ReadingEvent.last
      expect(reading_event_2.sensor_id).to eq 2
      expect(reading_event_2.start_read).to eq 100
      expect(reading_event_2.end_read).to eq 99
      expect(reading_event_2.read_difference).to eq(-1)
    end
  end
end
