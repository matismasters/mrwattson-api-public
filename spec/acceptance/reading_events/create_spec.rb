require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Reading Events' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  parameter :device_id, 'String::Particle deviceId', required: true

  parameter :data,
    'String::The reading event *data* should follow this format: ' \
    '"a|bbbbb.bb|ccccc.cc|-a|bbbbb.bb|ccccc.cc|-a|bbbbb.bb|ccccc.cc|-' \
    'a|bbbbb.bb|ccccc.cc". ' \
    '(a) => sensor_id(0,1,2,3). ' \
    '(b) => first_read(Amps). ' \
    '(c) => second_read(Amps). ' \
    '(|) => separates fields. ' \
    '(-) => separates rows. ' \
    'The string should not end with | or -.' \
    'There should not be a | after -.' \
    'Each "Row" corresponds to a reading event from ONE sensor, the format ' \
    'is prepared to support the reading events of several sensors in the ' \
    'same published event, but it can also recieve one alone like ' \
    'a|bbb.bb|cc.cc and it will work fine.',
    required: true

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
