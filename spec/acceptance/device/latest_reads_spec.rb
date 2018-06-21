require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Devices' do
  include DefaultHeaders
  include AuthenticationHelpers

  before do
    add_signed_in_user_authentication_headers
  end

  get '/devices/:device_id/reading_events/latest' do
    parameter :device_id, 'Integer::The device id'

    response_field :sensors_last_reads,
      'Array::Each item has the latest end_read to each sensor, ' \
      'in that corresponding order. sensor_id: 1 => array[1], ' \
      'sensor_id: 2 => array[2], and so on. array[0] is always 0'

    example 'Get latestet readings for a device in JSON format' do
      device1, device2 = create_list :device, 2

      # Creating several readings to make sure later we pick up the latest
      create_list :reading_event, 2, device: device1, sensor_id: 1
      create_list :reading_event, 2, device: device1, sensor_id: 2
      create_list :reading_event, 2, device: device1, sensor_id: 3
      create_list :reading_event, 2, device: device1, sensor_id: 4

      create_list :reading_event, 2, device: device2, sensor_id: 3
      create_list :reading_event, 2, device: device2, sensor_id: 4

      # Creating the latest reads
      create :reading_event,
        device: device1,
        sensor_id: 1,
        end_read: 100

      create :reading_event,
        device: device1,
        sensor_id: 2,
        end_read: 200

      create :reading_event,
        device: device1,
        sensor_id: 3,
        end_read: 300

      create :reading_event,
        device: device1,
        sensor_id: 4,
        end_read: 400

      do_request(device_id: device1.id)

      json_response = JSON.parse(response_body)

      expect(json_response.class).to eq Hash
      last_reads = json_response['sensors_last_reads']
      expect(last_reads[1]).to eq 100
      expect(last_reads[2]).to eq 200
      expect(last_reads[3]).to eq 300
      expect(last_reads[4]).to eq 400
    end
  end
end
