require 'spec_helper'

describe 'Device' do
  describe 'configuraiton' do
    it 'should save the configuration on create' do
      create :device, particle_id: 'ABC',
        configuration: {
          sensor_1_active: true,
          sensor_1_label: 'one',
          sensor_2_active: true,
          sensor_2_label: 'two',
          sensor_3_active: false,
          sensor_3_label: 'three',
          sensor_4_active: false,
          sensor_4_label: 'four'
        }

      device = Device.find_by_particle_id('ABC')
      expect(device.configuration[:sensor_1_active]).to eq true
      expect(device.configuration[:sensor_2_active]).to eq true
      expect(device.configuration[:sensor_3_active]).to eq false
      expect(device.configuration[:sensor_4_active]).to eq false
      expect(device.sensor_1_label).to eq 'one'
      expect(device.sensor_2_label).to eq 'two'
      expect(device.sensor_3_label).to eq 'three'
      expect(device.sensor_4_label).to eq 'four'
    end

    it 'should update the configuration on save' do
      device = create :device, particle_id: 'ABC',
        configuration: {
          sensor_1_active: true,
          sensor_1_label: 'one',
          sensor_2_active: true,
          sensor_2_label: 'two',
          sensor_3_active: false,
          sensor_3_label: 'three',
          sensor_4_active: false,
          sensor_4_label: 'four'
        }

      device.merge_configuration(
        sensor_1_label: '1one',
        sensor_2_label: '2two',
        sensor_3_label: '3three',
        sensor_4_label: '4four'
      )

      device.save

      expect(device.configuration[:sensor_1_active]).to eq true
      expect(device.configuration[:sensor_2_active]).to eq true
      expect(device.configuration[:sensor_3_active]).to eq false
      expect(device.configuration[:sensor_4_active]).to eq false
      expect(device.sensor_1_label).to eq '1one'
      expect(device.sensor_2_label).to eq '2two'
      expect(device.sensor_3_label).to eq '3three'
      expect(device.sensor_4_label).to eq '4four'
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

    it 'should return opportunity only if weekly notification was created within ' \
       '1 week and it was marked as opportunity' do
      device = create :device
      notification = create :notification,
        frequency: 'weekly',
        type: 'Opportunity'

      now = Time.now
      Timecop.freeze(now)

      device_notification = create :device_notification,
        device: device,
        notification: notification

      Timecop.freeze(now + 3.days)

      opportunities = device.active_opportunities
      expect(opportunities.size).to eq 1
      expect(opportunities.first.id).to eq device_notification.id

      Timecop.freeze(now + 8.days)

      expect(device.active_opportunities.size).to eq 0
    end

    it 'should return opportunity only if monthly notification was created within ' \
       '1 month and it was marked as opportunity' do
      device = create :device
      notification = create :notification,
        frequency: 'monthly',
        type: 'Opportunity'

      now = Time.now
      Timecop.freeze(now)

      device_notification = create :device_notification,
        device: device,
        notification: notification

      Timecop.freeze(now + 3.days)

      opportunities = device.active_opportunities
      expect(opportunities.size).to eq 1
      expect(opportunities.first.id).to eq device_notification.id

      Timecop.freeze(now + 2.month)

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

      create :device_notification,
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
