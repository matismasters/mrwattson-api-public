class ChangeFirstAndSecondReadToStartAndEnd < ActiveRecord::Migration
  def change
    rename_column :reading_events, :first_read, :start_read
    rename_column :reading_events, :second_read, :end_read
  end
end
