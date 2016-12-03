require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Devices' do
  include DefaultHeaders
  include AuthenticationHelpers

  before do
    add_signed_in_user_authentication_headers
  end

  parameter :device_id, 'Integer::The device id'

  get '/devices/:device_id/configuration' do
    response_field :configuration,
      'Hash::Each key contains configurations specific to this device'

    example 'Get device configuration' do
      device = create :device, configuration: {
        sensor_1_active: true,
        sensor_2_active: true,
        sensor_3_active: false,
        sensor_4_active: false
      }

      do_request(device_id: device.id)

      configuration = JSON.parse(response_body)['configuration']
      expect(configuration.class).to be Hash
      expect(configuration).not_to be_empty
      expect(configuration['sensor_1_active']).to be_truthy
      expect(configuration['sensor_2_active']).to be_truthy
      expect(configuration['sensor_3_active']).to be_falsy
      expect(configuration['sensor_4_active']).to be_falsy
    end

    example 'Get device sensor configuration if not set', document: false do
      device = create :device

      do_request(device_id: device.id)

      configuration = JSON.parse(response_body)['configuration']

      expect(configuration.class).to be Hash
      expect(configuration).not_to be_empty
      expect(configuration['sensor_1_active']).to be_truthy
      expect(configuration['sensor_2_active']).to be_truthy
      expect(configuration['sensor_3_active']).to be_truthy
      expect(configuration['sensor_4_active']).to be_truthy
    end
  end

  put '/devices/:device_id/configuration' do
    parameter :configuration,
      'Hash::Each key should have to corresponding value for the configuration'

    parameter :'*sensor_1_active',
      'Boolean::True if the sensor is active, false if not active/used'

    parameter :'*sensor_2_active',
      'Boolean::True if the sensor is active, false if not active/used'

    parameter :'*sensor_3_active',
      'Boolean::True if the sensor is active, false if not active/used'

    parameter :'*sensor_4_active',
      'Boolean::True if the sensor is active, false if not active/used'

    example 'Set device configuration' do
      device = create :device,
        particle_id: 'AXYZ',
        configuration: {
          sensor_1_active: false,
          sensor_2_active: false,
          sensor_3_active: false,
          sensor_4_active: false
        }

      do_request(
        device_id: device.id,
        configuration: {
          sensor_1_active: true,
          sensor_2_active: false,
          sensor_3_active: true,
          sensor_4_active: false
        }
      )

      configuration = device.reload.configuration
      expect(configuration[:sensor_1_active]).to be_truthy
      expect(configuration[:sensor_2_active]).to be_falsy
      expect(configuration[:sensor_3_active]).to be_truthy
      expect(configuration[:sensor_4_active]).to be_falsy
      expect(status).to eq 200
    end

    example 'Set device configuration with missing keys', document: false do
      device = create :device,
        particle_id: 'AXYZ',
        configuration: {
          sensor_1_active: false,
          sensor_2_active: false,
          sensor_3_active: false,
          sensor_4_active: false
        }

      do_request(
        device_id: device.id,
        configuration: {
          sensor_1_active: true,
          sensor_3_active: true,
        }
      )

      configuration = device.reload.configuration
      expect(configuration[:sensor_1_active]).to be_truthy
      expect(configuration[:sensor_2_active]).to be_falsy
      expect(configuration[:sensor_3_active]).to be_truthy
      expect(configuration[:sensor_4_active]).to be_falsy
      expect(status).to eq 200
    end
  end
end
