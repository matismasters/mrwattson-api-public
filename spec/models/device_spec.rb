require 'spec_helper'

describe 'Device' do
  describe 'this_month_notifications' do
    let(:device) { create :device }
    let(:notification1) do
      create :notification, name: 'notification1', once_a_month: true
    end
    let(:notification2) do
      create :notification, name: 'notification2', once_a_month: true
    end

    describe '#clean_this_month_notifications' do
      describe 'when same month' do
        it 'should not clean' do
          device.update_this_month_notifications(notification1)
          expect(device.this_month_notifications).to eq 'notification1'

          device.clean_this_month_notifications

          expect(device.this_month_notifications).to eq 'notification1'
        end
      end

      describe 'when different month' do
        it 'should clean' do
          device.update_this_month_notifications(notification1)
          expect(device.this_month_notifications).to eq 'notification1'

          Timecop.freeze Time.now + 1.month

          device.clean_this_month_notifications

          expect(device.this_month_notifications).to be_empty
        end
      end
    end

    describe '#update_this_month_notifications' do
      describe 'all notifications within the same month' do
        it 'should be added' do
          device.update_this_month_notifications(notification1)
          expect(device.this_month_notifications).to eq 'notification1'

          device.update_this_month_notifications(notification2)
          expect(device.this_month_notifications).to(
            eq 'notification1,notification2'
          )
        end

        it 'should be added only once' do
          device.update_this_month_notifications(notification1)
          device.update_this_month_notifications(notification1)
          expect(device.this_month_notifications).to eq 'notification1'

          device.update_this_month_notifications(notification2)
          device.update_this_month_notifications(notification2)
          expect(device.this_month_notifications).to(
            eq 'notification1,notification2'
          )
        end
      end

      describe 'one notification each month' do
        it 'should add, clean, and add' do
          device.update_this_month_notifications(notification1)
          device.update_this_month_notifications(notification1)
          expect(device.this_month_notifications).to eq 'notification1'

          device.update_this_month_notifications(notification2)
          device.update_this_month_notifications(notification2)
          expect(device.this_month_notifications).to(
            eq 'notification1,notification2'
          )

          Timecop.freeze Time.now + 1.month

          device.update_this_month_notifications(notification2)
          expect(device.this_month_notifications).to eq 'notification2'
        end
      end
    end
  end

  describe 'configuraiton' do
    it 'should save the configuration on create' do
      create(
        :device,
        particle_id: 'ABC',
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
      )

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
      device = create(
        :device,
        particle_id: 'ABC',
        configuration: {
          sensor_1_active: true,
          sensor_1_label: 'one',
          sensor_2_active: true,
          sensor_2_label: 'two',
          sensor_3_active: false,
          sensor_3_label: 'three',
          sensor_4_active: false,
          sensor_4_label: 'four',
          'sensor_1_active' => false,
          'sensor_1_label' => 'one1',
          'sensor_2_active' => false,
          'sensor_2_label' => 'two2',
          'sensor_3_active' => true,
          'sensor_3_label' => 'three3',
          'sensor_4_active' => true,
          'sensor_4_label' => 'four4'
        }
      )
      device.merge_configuration(device.configuration)
      expect(device.configuration[:sensor_1_active]).to eq false
      expect(device.configuration[:sensor_1_label]).to eq 'one1'
    end

    it 'should update the configuration on save' do
      device = create(
        :device,
        particle_id: 'ABC',
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
      )

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
      notification1 = create :notification,
        frequency: 'daily',
        type: 'Opportunity'

      notification2 = create :notification,
        frequency: 'daily',
        type: 'Opportunity'

      now = Time.now
      Timecop.freeze(now)

      create :device_notification,
        device: device,
        notification: notification1

      device_notification2 = create :device_notification,
        device: device,
        notification: notification1

      device_notification3 = create :device_notification,
        device: device,
        notification: notification2

      Timecop.freeze(now + 18.hours)

      opportunities = device.active_opportunities

      expect(opportunities.size).to eq 2
      expect(opportunities.map(&:id)).to include device_notification2.id
      expect(opportunities.map(&:id)).to include device_notification3.id

      Timecop.freeze(now + 25.hours)

      expect(device.active_opportunities.size).to eq 0
    end
  end

  after do
    Timecop.return
  end
end
