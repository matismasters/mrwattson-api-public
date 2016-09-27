class AddAssignedDevicesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :assigned_devices, :string
  end
end
