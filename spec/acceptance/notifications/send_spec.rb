require 'spec_helper'

describe 'Sending notifications' do
  let(:queue_manager) { class_double('NotificationSenderQueue') }

  describe 'for 1 device' do
    it 'should add the notification to the send queue for that user' do
      device = create :device
      create_list :reading_event, 10, device: device

      notification = create :notification,
        sql_query: 'SELECT device_id, MAX(read_difference) AS ' \
          'max_read_difference FROM reading_events GROUP BY device_id',
        tokens: 'max_read_difference',
        body: 'The max event diff is {{max_read_difference}}'

      maximum = ReadingEvent.maximum(:read_difference)

      expect(queue_manager).to(
        receive(:enqueue).with(
          device_id: device.id,
          notification_id: notification.id,
          token_values: { 'max_read_difference' => maximum.to_s },
          title: notification.title,
          body: "The max event diff is #{maximum}"
        )
      )

      notification.process_and_send(queue_manager)
    end
  end

  describe 'for 2 devices' do
    it 'should add the notification only to the one matching the criteria' do
      device_1, device_2 = create_list :device, 2
      create_list :reading_event, 10, device: device_1
      create_list :reading_event, 10, device: device_2

      notification = create :notification,
        sql_query:
          'SELECT device_id, MAX(read_difference) AS max_read_difference ' \
          'FROM reading_events ' \
          "WHERE device_id = #{device_1.id} " \
          'GROUP BY device_id',
        tokens: 'max_read_difference',
        body: 'The max event diff is {{max_read_difference}}'

      device_1_maximum = ReadingEvent
        .where('device_id = ?', device_1.id)
        .maximum(:read_difference)

      device_2_maximum = ReadingEvent
        .where('device_id = ?', device_2.id)
        .maximum(:read_difference)

      expect(queue_manager).to(
        receive(:enqueue).with(
          device_id: device_1.id,
          notification_id: notification.id,
          token_values: { 'max_read_difference' => device_1_maximum.to_s },
          title: notification.title,
          body: "The max event diff is #{device_1_maximum}"
        )
      )

      expect(queue_manager).not_to(
        receive(:enqueue).with(
          device_id: device_2.id,
          notification_id: notification.id,
          token_values: { 'max_read_difference' => device_2_maximum.to_s },
          title: notification.title,
          body: "The max event diff is #{device_2_maximum}"
        )
      )

      notification.process_and_send(queue_manager)
    end

    it 'should add the notification to the send queue for both users' do
      device_1, device_2 = create_list :device, 2
      create_list :reading_event, 10, device: device_1
      create_list :reading_event, 10, device: device_2

      notification = create :notification,
        sql_query: 'SELECT device_id, MAX(read_difference) AS ' \
          'max_read_difference FROM reading_events GROUP BY device_id',
        tokens: 'max_read_difference',
        body: 'The max event diff is {{max_read_difference}}'

      device_1_maximum = ReadingEvent
        .where('device_id = ?', device_1.id)
        .maximum(:read_difference)

      device_2_maximum = ReadingEvent
        .where('device_id = ?', device_2.id)
        .maximum(:read_difference)

      expect(queue_manager).to(
        receive(:enqueue).with(
          device_id: device_1.id,
          notification_id: notification.id,
          token_values: { 'max_read_difference' => device_1_maximum.to_s },
          title: notification.title,
          body: "The max event diff is #{device_1_maximum}"
        )
      )

      expect(queue_manager).to(
        receive(:enqueue).with(
          device_id: device_2.id,
          notification_id: notification.id,
          token_values: { 'max_read_difference' => device_2_maximum.to_s },
          title: notification.title,
          body: "The max event diff is #{device_2_maximum}"
        )
      )

      notification.process_and_send(queue_manager)
    end
  end
end
