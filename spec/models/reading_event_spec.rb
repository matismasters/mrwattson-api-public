require 'spec_helper'

describe 'ReadingEvent', type: :unit do
  let(:device) { create :device }
  it 'should return timestamps localized in Montevideo' do
    reading_event = create :reading_event, device: device

    expect(reading_event.created_at.zone).to eq 'UYT'
    expect(reading_event.updated_at.zone).to eq 'UYT'
  end

  it 'should return nil when object not saved' do
    reading_event = ReadingEvent.new
    expect(reading_event.created_at).to be_nil
  end

  it 'should save the time since last read in seconds' do
    Timecop.freeze(Time.now)

    create :reading_event, device: device

    Timecop.freeze(Time.now + 500.seconds)

    reading_event = create :reading_event, device: device

    reading_event.reload

    expect(reading_event.seconds_since_last_read).to eq 500
  end

  after do
    Timecop.return
  end
end
