require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Reading Events' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  parameter :device_id, 'String::Particle deviceId', required: true
  parameter :sensor_id, 'Number::Sensor identifier(0, 1, 2, 3)', required: true
  parameter :first_read,
    'Decimal::Read before the change(Amps). Use "." to separate decimals',
    required: true
  parameter :second_read,
    'Decimal::Read after the change(Amps). Use "." to separate decimals',
    required: true

  let(:reading_event_params) do
    first_read = rand(0..4000)
    {
      device_id: Faker::Number.hexadecimal(10),
      sensor_id: rand(0..3),
      first_read: first_read,
      second_read: first_read + rand(0..1000)
    }
  end

  post '/reading_events' do
    example 'Create ReadingEvent' do
      device = Device.create particle_id: reading_event_params[:device_id]
      do_request(reading_event_params)

      expect(status).to eq 201
      reading_event = ReadingEvent.last
      expect(reading_event.device_id).to eq device.id
      expect(reading_event.sensor_id).to eq reading_event_params[:sensor_id]
      expect(reading_event.first_read).to eq reading_event_params[:first_read]
      expect(reading_event.second_read).to eq reading_event_params[:second_read]
    end

    example 'Create ReadingEvent with an inexistant device_id' do
      do_request(reading_event_params)

      json_response = JSON.parse(response_body)

      expect(status).to eq 404
      expect(json_response['device_id']).to include 'not found'
    end

    example 'Create reading event without required fields', document: false do
      particle_id = reading_event_params[:device_id]
      Device.create particle_id: particle_id

      do_request(device_id: particle_id)

      json_response = JSON.parse(response_body)

      expect(status).to eq 422
      expect(json_response['sensor_id']).to include "can't be blank"
      expect(json_response['first_read']).to include "can't be blank"
      expect(json_response['second_read']).to include "can't be blank"
    end
  end
end
