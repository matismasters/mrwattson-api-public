require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Reading Events' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  parameter :device_id, 'String::Particle deviceId', required: true

  parameter :data, 'String::MultiValue:: ' \
    '"sensor_id|first_read|second_read"',
    required: true

  parameter :'*data_sensor_id', 'Number::[0,1,2,3]'
  parameter :'*data_first_read', 'Number::In watts'
  parameter :'*data_second_read', 'Number::In watts'

  let(:reading_event_params) do
    { device_id: Faker::Number.number(10), data: '2|123|321' }
  end

  post '/reading_events' do
    example 'Create ReadingEvent' do
      device = Device.create particle_id: reading_event_params[:device_id]
      do_request(reading_event_params)

      expect(status).to eq 201
      reading_event = ReadingEvent.last

      expect(reading_event.device_id).to eq device.id
      expect(reading_event.sensor_id).to eq 2
      expect(reading_event.first_read).to eq 123
      expect(reading_event.second_read).to eq 321
    end

    example 'Create ReadingEvent with an inexistant device_id' do
      do_request(reading_event_params)

      json_response = JSON.parse(response_body)

      expect(status).to eq 404
      expect(json_response['device_id']).to include 'not found'
    end

    example 'Create Reading Event without required fields', document: false do
      skip 'TODO: create failing examples for multiple events some failing'
      particle_id = reading_event_params[:device_id]
      Device.create particle_id: particle_id

      do_request(device_id: particle_id, data: [])

      json_response = JSON.parse(response_body)

      expect(status).to eq 422
      expect(json_response['sensor_id']).to include "can't be blank"
      expect(json_response['first_read']).to include "can't be blank"
      expect(json_response['second_read']).to include "can't be blank"
    end
  end
end
