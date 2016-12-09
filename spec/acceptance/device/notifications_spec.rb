require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Devices' do
  include DefaultHeaders
  include AuthenticationHelpers

  before do
    add_signed_in_user_authentication_headers
  end

  parameter :device_id, 'String::Particle deviceId', required: true
  response_field :notifications, 'Array::All notifications'
  response_field :'*title', 'String::Notification title'
  response_field :'*body', 'String::Notification summary'
  response_field :'*processed_discovery', 'String::Details about what was found'
  response_field :'*processed_opportunity', 'String::Details about what can be improved'
  response_field :'*processed_solution', 'String::Details about how to improve it'
  response_field :'*notification_type', 'String::Report or Opportunity'
  response_field :'*notification_id', 'Int::Internal notification id'
  response_field :'*token_values', 'Hash::Extracted result values from the notification query'

  get '/devices/:device_id/notifications' do
    example 'Get All notifications sorted by most recent' do
      device = create :device
      notification = create :notification

      create_list(
        :device_notification,
        5,
        device_id: device.id,
        notification_id: notification.id
      )

      do_request(device_id: device.id)

      json_response = JSON.parse(response_body)['notifications']

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

  get '/devices/:device_id/active_opportunities' do
    example 'Get active opportunities sorted by most recent' do
      device = create :device
      notification_1 = create :notification, type: 'Opportunity'
      notification_2 = create :notification, type: 'Opportunity'

      create_list(
        :device_notification,
        5,
        device_id: device.id,
        notification_id: notification_1.id
      )

      create_list(
        :device_notification,
        5,
        device_id: device.id,
        notification_id: notification_2.id
      )

      do_request(device_id: device.id)

      json_response = JSON.parse(response_body)['notifications']

      expect(json_response.class).to be Array
      expect(json_response.size).to be 2

      first_device_notificaiton = json_response.first
      expect(first_device_notificaiton['title']).not_to be_empty
      expect(first_device_notificaiton['body']).not_to be_empty
      expect(first_device_notificaiton['device_id']).to eq device.id
      expect(first_device_notificaiton['notification_id']).to eq notification_1.id

      expect(first_device_notificaiton['token_values'].class).to be Hash
    end
  end
end
