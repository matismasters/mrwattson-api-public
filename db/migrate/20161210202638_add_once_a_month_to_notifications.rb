class AddOnceAMonthToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :once_a_month, :boolean, default: false
  end
end
