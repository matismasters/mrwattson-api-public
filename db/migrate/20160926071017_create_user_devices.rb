class CreateUserDevices < ActiveRecord::Migration
  def change
    create_table :user_devices do |t|
      t.integer :device_id
      t.integer :user_id
    end

    add_index :user_devices, [:device_id, :user_id]
    add_index :user_devices, :device_id
    add_index :user_devices, :user_id
  end
end
