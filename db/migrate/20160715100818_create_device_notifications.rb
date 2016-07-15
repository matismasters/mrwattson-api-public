class CreateDeviceNotifications < ActiveRecord::Migration
  def change
    create_table :device_notifications do |t|
      t.integer :device_id
      t.integer :notification_id
      t.boolean :opened
      t.string :token_values

      t.timestamps null: false
    end

    add_index :device_notifications, :device_id
    add_index :device_notifications, :notification_id
    add_index :device_notifications, [:device_id, :notification_id]
  end
end
