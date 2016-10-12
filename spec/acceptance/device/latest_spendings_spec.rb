require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Device' do
  include DefaultHeaders
  include AuthenticationHelpers

  before do
    add_signed_in_user_authentication_headers
  end

  get '/devices/:device_id/latest_spendings' do
    parameter :device_id, 'Integer::The device id'

    response_field :latest_spendings, 'Hash::with latest spending calculations '
    response_field :'*yesterday_from_last_week',
      'Float::Calculation in pesos of 8 days before today'
    response_field :'*yesterday',
      'Float::Calculation in pesos of 1 day before today'
    response_field :'*latest_hours',
      'Array::Each item contains the spending the current hour minus the ' \
      'array index + 1. Example: hourly_spendings[0] => spendings from ' \
      '1 hour ago'

    after do
      Timecop.return
    end

    example 'Get latest spendings for device' do
      device = create :device
      now = Time.now

      # Creating event for 8 days back
      current_day = now - 8.days
      Timecop.freeze(current_day)
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 86400

      # Creating event for yesterday
      Timecop.freeze(now - 1.day)
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 86400

      # Creating events for latest hours
      Timecop.freeze(now - 3.hours)
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 3600

      Timecop.freeze(now - 2.hours)
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 3600

      Timecop.freeze(now - 1.hour)
      create :reading_event,
        device_id: device.id,
        start_read: 0,
        end_read: 1000,
        sensor_id: 1,
        seconds_until_next_read: 3600

      Timecop.freeze(now)

      do_request(device_id: device.id)

      json_response = JSON.parse(response_body)

      expect(json_response['latest_spendings']).to be_a(Hash)
      expect(json_response['latest_spendings']['yesterday_from_last_week']).to eq 120
      expect(json_response['latest_spendings']['yesterday']).to eq 120
      expect(json_response['latest_spendings']['latest_hours']).to be_a(Array)
      expect(json_response['latest_spendings']['latest_hours'][0]).to eq 5
      expect(json_response['latest_spendings']['latest_hours'][1]).to eq 5
      expect(json_response['latest_spendings']['latest_hours'][2]).to eq 5
    end

  end
end
