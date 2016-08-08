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

  describe 'opportunities' do
    it 'should return opportunity only if daily notification was created within ' \
       '24 hours and it was marked as opportunity' do
      device = create :device
      notification = create :notification,
        frequency: 'daily',
        type: 'Opportunity'

      now = Time.now
      Timecop.freeze(now)

      device_notification = create :device_notification,
        device: device,
        notification: notification

      Timecop.freeze(now + 18.hours)

      opportunities = device.active_opportunities
      expect(opportunities.size).to eq 1
      expect(opportunities.first.id).to eq device_notification.id

      Timecop.freeze(now + 25.hours)

      expect(device.active_opportunities.size).to eq 0
    end

    it 'should return only the latest device notification of each notification ' do
      device = create :device
      notification_1 = create :notification,
        frequency: 'daily',
        type: 'Opportunity'

      notification_2 = create :notification,
        frequency: 'daily',
        type: 'Opportunity'

      now = Time.now
      Timecop.freeze(now)

      device_notification_1 = create :device_notification,
        device: device,
        notification: notification_1

      device_notification_2 = create :device_notification,
        device: device,
        notification: notification_1

      device_notification_3 = create :device_notification,
        device: device,
        notification: notification_2

      Timecop.freeze(now + 18.hours)

      opportunities = device.active_opportunities
      opportunity_ids = opportunities.map(&:id)

      expect(opportunities.size).to eq 2
      expect(opportunities.map(&:id)).to include device_notification_2.id
      expect(opportunities.map(&:id)).to include device_notification_3.id

      Timecop.freeze(now + 25.hours)

      expect(device.active_opportunities.size).to eq 0
    end

    after do
      Timecop.return
    end
  end
end
