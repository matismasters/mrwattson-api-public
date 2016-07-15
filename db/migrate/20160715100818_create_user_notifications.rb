class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.integer :user_id
      t.integer :notification_id
      t.boolean :opened

      t.timestamps null: false
    end

    add_index :user_notifications, :user_id
    add_index :user_notifications, :notification_id
    add_index :user_notifications, [:user_id, :notification_id]
  end
end
