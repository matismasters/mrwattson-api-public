require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Reading Events' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  get '/reading_events' do
    example 'Get latest week events in JSON format' do
      device = create :device
      create_list :reading_event, 5, device: device
      do_request

      json_response = JSON.parse(response_body)

      expect(json_response.class).to eq Array
      expect(json_response.size).to(
        eq(ReadingEvent.where('created_at >= ?', Time.now - 7.days).size)
      )
    end
  end

  get '/reading_events/latest' do
    parameter :device_id, 'String::The device id from Particle'

    response_field :sensors_last_reads,
      'Array::Each item has the latest end_read to each sensor, ' \
      'in that corresponding order. sensor_id: 1 => array[1], ' \
      'sensor_id: 2 => array[2], and so on. array[0] is always 0'

    example 'Get latestet readings for a device in JSON format' do
      device_1, device_2 = create_list :device, 2

      # Creating several readings to make sure later we pick up the latest
      create_list :reading_event, 2, device: device_1, sensor_id: 1
      create_list :reading_event, 2, device: device_1, sensor_id: 2
      create_list :reading_event, 2, device: device_1, sensor_id: 3
      create_list :reading_event, 2, device: device_1, sensor_id: 4

      create_list :reading_event, 2, device: device_2, sensor_id: 3
      create_list :reading_event, 2, device: device_2, sensor_id: 4

      # Creating the latest reads
      create :reading_event,
        device: device_1,
        sensor_id: 1,
        end_read: 100

      create :reading_event,
        device: device_1,
        sensor_id: 2,
        end_read: 200

      create :reading_event,
        device: device_1,
        sensor_id: 3,
        end_read: 300

      create :reading_event,
        device: device_1,
        sensor_id: 4,
        end_read: 400

      do_request(device_id: device_1.particle_id)

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
