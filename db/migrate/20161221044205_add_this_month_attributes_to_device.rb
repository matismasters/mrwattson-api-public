class AddThisMonthAttributesToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :this_month, :integer
    add_column :devices, :this_month_notifications, :string
  end
end
