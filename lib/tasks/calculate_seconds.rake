namespace :calculate_seconds do
  desc 'Makes sure all the seconds_until_next_read fields have the right value'
  task all: :environment do
    ReadingEvent.recalculate_seconds_between_all_reading_events
  end
end
