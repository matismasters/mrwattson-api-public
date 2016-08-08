require 'spec_helper'

describe 'Sending notifications' do
  let(:queue_manager) { class_double('NotificationSenderJob') }
  let(:notification_attributes) do
    {
      sql_query: 'SELECT device_id, MAX(read_difference) AS max_read_difference ' \
        'FROM reading_events ' \
        'GROUP BY device_id ' \
        'HAVING MAX(read_difference) <= 1000',
      tokens: 'max_read_difference',
      title: 'Max is {{max_read_difference}}',
      body: 'The max event diff is {{max_read_difference}}',
      type: 'Opportunity',
      discovery: 'We found {{max_read_difference}}w is your max read difference',
      opportunity: '{{max_read_difference}}w could be lower',
      solution: 'Change the appliance that uses {{max_read_difference}}w'
    }
  end

  let(:enqueue_expected_params) do
    {
      token_values: { 'max_read_difference' => '150' },
      title: 'Max is 150',
      body: 'The max event diff is 150',
      processed_discovery: 'We found 150w is your max read difference',
      processed_opportunity: '150w could be lower',
      processed_solution: 'Change the appliance that uses 150w'
    }
  end

  describe 'for 1 device' do
    it 'should add the notification to the send queue for that user' do
      device = create :device
      create :reading_event, device: device, start_read: 0, end_read: 150
      notification = create :notification, notification_attributes

      expect(queue_manager).to(
        receive(:enqueue).with(
          enqueue_expected_params.merge(
            device_id: device.id,
            notification_id: notification.id
          )
        )
      )

      notification.process_and_send(queue_manager)
    end
  end

  describe 'for 2 devices' do
    it 'should add the notification only to the one matching the criteria' do
      device_1 = create :device
      device_2 = create :device
      create :reading_event, device: device_1, start_read: 0, end_read: 150
      create :reading_event, device: device_2, start_read: 0, end_read: 1500
      notification = create :notification, notification_attributes

      expect(queue_manager).to(
        receive(:enqueue).with(
          enqueue_expected_params.merge(
            device_id: device_1.id,
            notification_id: notification.id
          )
        )
      )

      expect(queue_manager).not_to(
        receive(:enqueue).with(
          enqueue_expected_params.merge(
            device_id: device_2.id,
            notification_id: notification.id
          )
        )
      )

      notification.process_and_send(queue_manager)
    end

    it 'should add the notification to the send queue for both users' do
      device_1 = create :device
      device_2 = create :device
      create :reading_event, device: device_1, start_read: 0, end_read: 150
      create :reading_event, device: device_2, start_read: 0, end_read: 150
      notification = create :notification, notification_attributes

      expect(queue_manager).to(
        receive(:enqueue).with(
          enqueue_expected_params.merge(
            device_id: device_1.id,
            notification_id: notification.id
          )
        )
      )

      expect(queue_manager).to(
        receive(:enqueue).with(
          enqueue_expected_params.merge(
            device_id: device_2.id,
            notification_id: notification.id
          )
        )
      )

      notification.process_and_send(queue_manager)
    end
  end
end
