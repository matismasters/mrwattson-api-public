class AddDiscoveryOpportunitySolutionToNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :opportunity
    add_column :notifications, :discovery, :string
    add_column :notifications, :opportunity, :string
    add_column :notifications, :solution, :string
  end
end
