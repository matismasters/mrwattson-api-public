class CreateLatestDeviceNotifications < ActiveRecord::Migration
  def change
    create_table :latest_device_notifications do |t|
      t.integer :device_notification_id
      t.integer :device_id
      t.integer :notification_id

      t.timestamps
    end

    add_index :latest_device_notifications, :device_notification_id
    add_index :latest_device_notifications, %i[device_id notification_id],
      name: 'device_and_notification'
  end
end
