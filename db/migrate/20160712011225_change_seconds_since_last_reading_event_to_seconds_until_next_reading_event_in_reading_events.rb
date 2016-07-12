class ChangeSecondsSinceLastReadingEventToSecondsUntilNextReadingEventInReadingEvents < ActiveRecord::Migration
  def change
    rename_column :reading_events,
      :seconds_since_last_read,
      :seconds_until_next_read
  end
end
