require 'spec_helper'

describe 'ReadingEvent', type: :unit do
  let(:device) { create :device }
  let(:start_time) { Time.now }

  it 'should return timestamps localized in Montevideo' do
    reading_event = create :reading_event, device: device

    expect(reading_event.created_at_montevideo.zone).to eq 'UYT'
    expect(reading_event.updated_at_montevideo.zone).to eq 'UYT'
  end

  it 'should return nil when object not saved' do
    reading_event = ReadingEvent.new
    expect(reading_event.created_at).to be_nil
  end

  it 'should save the time since last read in seconds' do
    Timecop.freeze(start_time)

    reading_event_1 = create :reading_event, device: device, sensor_id: 2
    create :reading_event, device: device, sensor_id: 3

    Timecop.freeze(start_time + 6.seconds)

    reading_event_2 = create :reading_event, device: device, sensor_id: 2

    Timecop.freeze(start_time + 12.seconds)

    create :reading_event, device: device, sensor_id: 2

    expect(reading_event_1.reload.seconds_until_next_read).to eq 6
    expect(reading_event_2.reload.seconds_until_next_read).to eq 6
  end

  it 'should be scoped to the sensor_id' do
    Timecop.freeze(start_time)

    reading_event = create :reading_event, device: device, sensor_id: 2

    Timecop.freeze(start_time + 6.seconds)

    create :reading_event, device: device, sensor_id: 3
    create :reading_event, device: device, sensor_id: 1
    create :reading_event, device: device, sensor_id: 3

    Timecop.freeze(start_time + 12.seconds)

    create :reading_event, device: device, sensor_id: 2

    expect(reading_event.reload.seconds_until_next_read).to eq 12
  end

  it 'should not change the seconds on save' do
    Timecop.freeze(start_time)

    create :reading_event, device: device, sensor_id: 2

    Timecop.freeze(start_time + 6.seconds)

    reading_event_2 = create :reading_event, device: device, sensor_id: 3

    expect(reading_event_2).not_to(
      receive(:calculate_seconds_since_last_reading_event)
    )

    reading_event_2.save
  end

  after do
    Timecop.return
  end
end
