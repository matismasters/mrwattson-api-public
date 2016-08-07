class AddOpportunityToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :opportunity, :boolean
  end
end
