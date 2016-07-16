require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Devices' do
  header 'Content-Type', 'application/json'
  header 'Accept', 'application/json'

  parameter :device_id, 'String::Particle deviceId', required: true

  get '/devices/:device_id/notifications' do
    example 'Get All notifications sorted by most recent' do
      device = create :device, particle_id: 'particleId123'
      notification = create :notification

      create_list(
        :device_notification,
        5,
        device_id: device.id,
        notification_id: notification.id
      )

      do_request(device_id: 'particleId123')

      json_response = JSON.parse(response_body)

      expect(json_response.class).to be Array
      expect(json_response.size).to be 5
      expect(json_response.first['device_id']).to eq device.id
      expect(json_response.first['notification_id']).to eq notification.id
    end
  end
end
