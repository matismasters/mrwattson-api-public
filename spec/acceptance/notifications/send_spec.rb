require 'spec_helper'

describe 'Sending notifications' do
  describe 'for 1 device' do
    it 'should add the notification to the send queue for that user' do
      device = create :device
      create_list :reading_event, 10, device: device

      notification = create :notification,
        sql_query: 'SELECT device_id, MAX(read_difference) AS ' \
          'max_read_difference FROM reading_events GROUP BY device_id',
        tokens: 'max_read_difference',
        body: 'The max event diff is {{max_read_difference}}'

      notification.process_and_send

      allow(NotificationSenderQueue).to(
        receive(:enqueue).with(
          device.id,
          notification.title,
          "The max event diff is #{ReadingEvent.maximum(:read_difference)}"
        )
      )
    end
  end

  describe 'for 2 devices' do
    it 'should add the notification to the send queue for that user' do
      device_1, device_2 = create_list :device, 2
      create_list :reading_event, 10, device: device_1
      create_list :reading_event, 10, device: device_2

      notification = create :notification,
        sql_query: 'SELECT device_id, MAX(read_difference) AS ' \
          'max_read_difference FROM reading_events GROUP BY device_id',
        tokens: 'max_read_difference',
        body: 'The max event diff is {{max_read_difference}}'

      notification.process_and_send

      device_1_maximum = ReadingEvent
        .where('device_id = ?', device_1.id)
        .maximum(:read_difference)

      device_2_maximum = ReadingEvent
        .where('device_id = ?', device_2.id)
        .maximum(:read_difference)

      allow(NotificationSenderQueue).to(
        receive(:enqueue).with(
          device_1.id,
          notification.title,
          "The max event diff is #{device_1_maximum}"
        )
      )

      allow(NotificationSenderQueue).to(
        receive(:enqueue).with(
          device_2.id,
          notification.title,
          "The max event diff is #{device_2_maximum}"
        )
      )
    end
  end
end
