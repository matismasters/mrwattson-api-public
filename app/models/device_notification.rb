class DeviceNotification < ActiveRecord::Base
  belongs_to :device
  belongs_to :notification, polymorphic: true

  serialize :token_values, Hash
  after_create :update_latest_device_notification_pointer
  before_save :update_notification_type

  def update_notification_type
    return if self.notification_id.blank?
    notification = Notification.find_by_id(self.notification_id)
    self.notification_type = notification.type if notification
  end

  private

  def update_latest_device_notification_pointer
    LatestDeviceNotification.find_or_create_by(
      device_id: device_id,
      notification_id: notification_id
    ).update_attribute(:device_notification_id, self.id)
  end
end
