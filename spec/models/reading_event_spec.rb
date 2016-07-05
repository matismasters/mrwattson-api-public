require 'spec_helper'

describe 'ReadingEvent', type: :unit do
  it 'should return timestamps localized in Montevideo' do
    device = Device.create(particle_id: 'testing')
    reading_event = ReadingEvent.create(
      device_id: device.id,
      sensor_id: 0,
      first_read: 1,
      second_read: 2
    )

    expect(reading_event.created_at.zone).to eq 'UYT'
    expect(reading_event.updated_at.zone).to eq 'UYT'
  end

  it 'should return nil when object not saved' do
    reading_event = ReadingEvent.new
    expect(reading_event.created_at).to be_nil
  end
end
