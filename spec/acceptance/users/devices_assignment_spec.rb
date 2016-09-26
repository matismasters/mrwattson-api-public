require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Users' do
  include DefaultHeaders
  include AuthenticationHelpers

  before do
    add_signed_in_user_authentication_headers
  end

  post '/users/devices' do
    parameter :device_id, 'String::The device id from Particle'

    example 'Assign device to current user' do
      device = create(:device)

      do_request(device_id: device.particle_id)

      expect([200, 201]).to include(status)
      expect(current_user.reload.devices.first.particle_id).to eq device.particle_id
    end

    example 'Assign is unique', document: false do
      device = create(:device)

      do_request(device_id: device.particle_id)

      expect(
        UserDevice.where(device_id: device.id, user_id: current_user.id).count
      ).to eq 1

      do_request(device_id: device.particle_id)

      expect(
        UserDevice.where(device_id: device.id, user_id: current_user.id).count
      ).to eq 1
    end

    example 'Without right device id', document: false do
      do_request(device_id: 'asdf')

      expect(status).to eq 404
    end
  end

  delete '/users/devices' do
    parameter :device_id, 'String::The device id from Particle'

    example 'Unassign device' do
      device = create(:device)
      create :user_device, device_id: device.id, user_id: current_user.id
      expect(current_user.reload.devices.size).to eq 1

      do_request(device_id: device.particle_id)

      expect(status).to eq 200
      expect(current_user.reload.devices.size).to eq 0
    end

    example 'Without right device id', document: false do
      do_request(device_id: 'asdf')

      expect(status).to eq 404
    end
  end
end
