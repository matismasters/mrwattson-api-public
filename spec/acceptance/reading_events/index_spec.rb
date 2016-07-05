require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Reading Events' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  get '/reading_events' do
    example 'Get latest week events in JSON format' do
      device = create :device
      create_list :reading_event, 5, device_id: device.id
      do_request

      json_response = JSON.parse(response_body)

      expect(json_response.class).to eq Array
      expect(json_response.size).to(
        eq(ReadingEvent.where('created_at >= ?', Time.now - 7.days).size)
      )
    end
  end

  get '/reading_events/latest' do
    example 'Get latestet readings for a device in JSON format' do
      device_1, device_2 = create_list :device, 2
      create_list :reading_event, 2, device_id: device_1.id
      create_list :reading_event, 2, device_id: device_2.id

      last_reading_for_device = create :reading_event, device_id: device_1.id

      do_request(device_id: device_1.particle_id)

      json_response = JSON.parse(response_body)

      expect(json_response.class).to eq Hash
      expect(json_response['id']).to eq last_reading_for_device.id
      expect(json_response['sensor_id']).to (
        eq(last_reading_for_device.sensor_id)
      )
      expect(json_response['first_read']).to (
        eq(last_reading_for_device.first_read)
      )
      expect(json_response['second_read']).to (
        eq(last_reading_for_device.second_read)
      )
    end
  end
end
