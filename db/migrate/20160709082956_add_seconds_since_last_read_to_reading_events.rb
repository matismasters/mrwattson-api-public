class AddSecondsSinceLastReadToReadingEvents < ActiveRecord::Migration
  def change
    add_column :reading_events, :seconds_since_last_read, :integer, default: 0
  end
end
