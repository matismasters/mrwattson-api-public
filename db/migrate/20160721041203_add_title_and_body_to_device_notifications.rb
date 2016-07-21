class AddTitleAndBodyToDeviceNotifications < ActiveRecord::Migration
  def change
    add_column :device_notifications, :title, :string
    add_column :device_notifications, :body, :string
  end
end
