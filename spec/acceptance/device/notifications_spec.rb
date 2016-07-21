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

      first_device_notificaiton = json_response.first
      expect(first_device_notificaiton['title']).not_to be_empty
      expect(first_device_notificaiton['body']).not_to be_empty
      expect(first_device_notificaiton['device_id']).to eq device.id
      expect(first_device_notificaiton['notification_id']).to eq notification.id

      expect(first_device_notificaiton['token_values'].class).to be Hash
    end
  end
end
