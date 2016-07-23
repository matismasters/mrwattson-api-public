require 'spec_helper'

describe 'Device' do
  describe 'configuraiton' do
    it 'should save the configuration on create' do
      create :device, particle_id: 'ABC',
        configuration: {
          sensor_1_active: true,
          sensor_2_active: true,
          sensor_3_active: false,
          sensor_4_active: false
        }

      device = Device.find_by_particle_id('ABC')
      expect(device.configuration[:sensor_1_active]).to eq true
      expect(device.configuration[:sensor_2_active]).to eq true
      expect(device.configuration[:sensor_3_active]).to eq false
      expect(device.configuration[:sensor_4_active]).to eq false
    end
  end
end
