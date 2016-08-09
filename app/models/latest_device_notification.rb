class LatestDeviceNotification < ActiveRecord::Base
  belongs_to :device_notification
  belongs_to :device
  belongs_to :notification

  def self.active_opportunities_for_device(device_id)
    now = Time.now
    DeviceNotification.where(id:
      joins(:notification)
      .where(%{(
          latest_device_notifications.updated_at >= ? AND
          notifications.frequency = ?
        ) OR (
          latest_device_notifications.updated_at >= ? AND
          notifications.frequency = ?
        ) OR (
          latest_device_notifications.updated_at >= ? AND
          notifications.frequency = ?
        )},
        now - 24.hours, 'daily',
        now - 1.week, 'weekly',
        now - 1.month, 'monthly'
      )
      .where(device_id: device_id)
      .where('notifications.type = ?', 'Opportunity')
      .order('latest_device_notifications.updated_at desc, notifications.frequency')
      .map(&:device_notification_id)
    )
  end
end
