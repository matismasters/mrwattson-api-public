class AddLastRunToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :last_run, :datetime
  end
end
