require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Reading Events' do
  include DefaultHeaders
  include AuthenticationHelpers

  before do
    add_signed_in_user_authentication_headers
  end

  parameter :device_id, 'String::Particle deviceId', required: true

  parameter :data, 'String::MultiValue:: ' \
    '"d-sensor_id|start_read|end_read" (The initial "d-" is required)',
    required: true

  parameter :'*data_sensor_id', 'Number::[1,2,3,4]'
  parameter :'*data_start_read', 'Number::In watts'
  parameter :'*data_end_read', 'Number::In watts'

  let(:reading_event_params) do
    { device_id: Faker::Number.number(10), data: 'd-2|123|321' }
  end

  post '/reading_events' do
    example 'Create ReadingEvent' do
      device = create :device, particle_id: reading_event_params[:device_id]
      do_request(reading_event_params)

      expect(status).to eq 201
      reading_event = ReadingEvent.last

      expect(reading_event.device_id).to eq device.id
      expect(reading_event.sensor_id).to eq 2
      expect(reading_event.start_read).to eq 123
      expect(reading_event.end_read).to eq 321
    end

    example 'Create ReadingEvent with an inexistant device_id should fail' do
      do_request(reading_event_params)

      json_response = JSON.parse(response_body)

      expect(status).to eq 404
      expect(json_response['device_id']).to include 'not found'
    end

    example 'Creating Reading Event without required fields should fail',
      document: false do
      particle_id = reading_event_params[:device_id]
      create :device, particle_id: particle_id

      do_request(device_id: particle_id, data: [])

      expect(status).to eq 400
    end

    example 'Create Reading Event for disabled sensors with <= 5000 end_read ' \
            'should succeed', document: false do
      particle_id = reading_event_params[:device_id]
      create :device, particle_id: particle_id
      create :device,
        particle_id: particle_id,
        configuration: {
          sensor_1_active: true,
          sensor_2_active: true,
          sensor_3_active: false,
          sensor_4_active: false
        }

      do_request(device_id: particle_id, data: 'd-3|100|200|-4|199|290')

      expect(status).to eq 201
      expect(ReadingEvent.count).to eq 2
    end

    example 'Create Reading Event for disabled sensors with >= 5000 end_read ' \
            'should fail', document: false do
      particle_id = reading_event_params[:device_id]
      create :device,
        particle_id: particle_id,
        configuration: {
          sensor_1_active: true,
          sensor_2_active: true,
          sensor_3_active: false,
          sensor_4_active: false
        }

      do_request(device_id: particle_id, data: 'd-3|100|5300|-4|199|5100')

      expect(status).to eq 422

      json_response = JSON.parse(response_body)
      expect(json_response['sensor_id3']['configuration']).to(
        include('sensor 3 is disabled')
      )
      expect(json_response['sensor_id4']['configuration']).to(
        include('sensor 4 is disabled')
      )
    end
  end
end
