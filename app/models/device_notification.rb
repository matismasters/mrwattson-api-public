class DeviceNotification < ActiveRecord::Base
  belongs_to :device
  belongs_to :notification

  serialize :token_values, Hash
  after_create :update_latest_device_notification_pointer

  private

  def update_latest_device_notification_pointer
    LatestDeviceNotification.find_or_create_by(
      device_id: device_id,
      notification_id: notification_id
    ).update_attribute(:device_notification_id, self.id)
  end
end
