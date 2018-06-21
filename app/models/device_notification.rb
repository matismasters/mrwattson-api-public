class DeviceNotification < ActiveRecord::Base
  belongs_to :device
  belongs_to :notification, polymorphic: true

  serialize :token_values, Hash
  before_save :update_notification_type

  after_create :update_latest_device_notification_pointer
  after_create(
    :update_device_this_month_notifications,
    if: proc { notification.present? && notification.once_a_month? }
  )

  def update_notification_type
    return if notification_id.blank?
    notification = Notification.find_by_id(notification_id)
    self.notification_type = notification.type if notification
  end

  private

  def update_latest_device_notification_pointer
    LatestDeviceNotification.find_or_create_by(
      device_id: device_id,
      notification_id: notification_id
    ).update_attribute(:device_notification_id, id)
  end

  def update_device_this_month_notifications
    return if notification_id.blank?
    device.update_this_month_notifications(notification)
  end
end
