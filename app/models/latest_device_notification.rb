class LatestDeviceNotification < ActiveRecord::Base
  belongs_to :device_notification
  belongs_to :device
  belongs_to :notification

  WHERE_CLAUSE = %{
    (
      latest_device_notifications.updated_at >= ? AND
      notifications.frequency = ?
    ) OR (
      latest_device_notifications.updated_at >= ? AND
      notifications.frequency = ?
    ) OR (
      latest_device_notifications.updated_at >= ? AND
      notifications.frequency = ?
    )
  }.freeze

  def self.active_opportunities_for_device(device_id)
    now = Time.now
    DeviceNotification.where(
      id:
      joins(:notification)
      .where(
        WHERE_CLAUSE,
        now - 24.hours,
        'daily',
        now - 1.week,
        'weekly',
        now - 1.month,
        'monthly'
      )
      .where(device_id: device_id)
      .where('notifications.type = ?', 'Opportunity')
      .order('latest_device_notifications.updated_at desc, notifications.frequency')
      .map(&:device_notification_id)
    )
  end

  def self.where_clause
  end
end
