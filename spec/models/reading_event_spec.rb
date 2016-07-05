require 'spec_helper'

describe 'ReadingEvent', type: :unit do
  it 'should return timestamps localized in Montevideo' do
    device = create :device
    reading_event = create :reading_event, device_id: device.id

    expect(reading_event.created_at.zone).to eq 'UYT'
    expect(reading_event.updated_at.zone).to eq 'UYT'
  end

  it 'should return nil when object not saved' do
    reading_event = ReadingEvent.new
    expect(reading_event.created_at).to be_nil
  end
end
