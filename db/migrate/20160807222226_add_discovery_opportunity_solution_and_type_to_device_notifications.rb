class AddDiscoveryOpportunitySolutionAndTypeToDeviceNotifications < ActiveRecord::Migration
  def change
    add_column :device_notifications, :notification_type, :string
    add_column :device_notifications, :processed_discovery, :string
    add_column :device_notifications, :processed_opportunity, :string
    add_column :device_notifications, :processed_solution, :string
  end
end
