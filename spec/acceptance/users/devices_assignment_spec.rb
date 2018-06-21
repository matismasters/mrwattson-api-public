require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Users' do
  include DefaultHeaders
  include AuthenticationHelpers

  before do
    add_signed_in_user_authentication_headers
  end

  get '/users/devices' do
    response_field :devices, 'Array::List of assigned devices'
    response_field :"*id", 'Integer::Particle id'
    response_field :"*type", 'String::Type of device'

    example 'Get all User Devices' do
      user_devices = create_list :user_device, 2, user: current_user

      do_request

      json_response = JSON.parse(response_body)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq 2

      devices_id = json_response.map { |device| device['id'] }
      expect(devices_id).to include(user_devices[0].device_id)
      expect(devices_id).to include(user_devices[1].device_id)
    end
  end

  post '/users/devices' do
    parameter :device_id, 'Integer::The device id'

    example 'Assign device to current user' do
      device = create(:device)

      do_request(device_id: device.id)

      expect([200, 201]).to include(status)
      expect(current_user.reload.devices.first.id).to eq device.id
    end

    example 'Assign multiple', document: false do
      device1 = create(:device)
      device2 = create(:device)

      do_request(device_id: device1.id)
      do_request(device_id: device2.id)

      expect(
        UserDevice.where(user_id: current_user.id).count
      ).to eq 2

      expect(current_user.reload.assigned_devices).to(
        eq("#{device1.id},#{device2.id}")
      )
    end

    example 'Assign is unique', document: false do
      device = create(:device)

      do_request(device_id: device.id)

      expect(
        UserDevice.where(device_id: device.id, user_id: current_user.id).count
      ).to eq 1

      do_request(device_id: device.id)

      expect(
        UserDevice.where(device_id: device.id, user_id: current_user.id).count
      ).to eq 1

      expect(current_user.reload.assigned_devices).to eq device.id.to_s
    end

    example 'Without right device id', document: false do
      do_request(device_id: 99_999)

      expect(status).to eq 404
    end
  end

  delete '/users/devices' do
    parameter :device_id, 'String::The device id from Particle'

    example 'Unassign device' do
      device = create(:device)
      create :user_device, device_id: device.id, user_id: current_user.id
      expect(current_user.reload.devices.size).to eq 1

      do_request(device_id: device.id)

      expect(status).to eq 200
      expect(current_user.reload.devices.size).to eq 0
    end

    example 'Without right device id', document: false do
      do_request(device_id: 99_999)

      expect(status).to eq 404
    end
  end
end
