class DeviceNotification < ActiveRecord::Base
  belongs_to :device
  belongs_to :notification, polymorphic: true

  serialize :token_values, Hash
  after_create :update_latest_device_notification_pointer
  before_save :update_notification_type

  private

  def update_notification_type
    self.notification_type = self.notification.type if self.notification
  end

  def update_latest_device_notification_pointer
    LatestDeviceNotification.find_or_create_by(
      device_id: device_id,
      notification_id: notification_id
    ).update_attribute(:device_notification_id, self.id)
  end
end
