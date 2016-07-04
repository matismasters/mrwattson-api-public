require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource '/reading_events' do
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
      do_request(reading_event_params)

      expect(status).to eq 201
      reading_event = ReadingEvent.last
      expect(reading_event.device_id).to eq reading_event_params[:device_id]
      expect(reading_event.sensor_id).to eq reading_event_params[:sensor_id]
      expect(reading_event.first_read).to eq reading_event_params[:first_read]
      expect(reading_event.second_read).to eq reading_event_params[:second_read]
    end

    example 'Create reading event without required fields', document: false do
      do_request

      json_response = JSON.parse(response_body)

      expect(status).to eq 422
      expect(json_response['device_id']).to include "can't be blank"
      expect(json_response['sensor_id']).to include "can't be blank"
      expect(json_response['first_read']).to include "can't be blank"
      expect(json_response['second_read']).to include "can't be blank"
    end
  end
end
