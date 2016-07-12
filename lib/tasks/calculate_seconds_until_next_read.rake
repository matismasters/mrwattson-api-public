namespace :calculate_seconds_until_next_read do
  desc "Makes sure all the seconds_until_next_read fields have the right value"
  task all: :environment do
    previous_read = nil
    ReadingEvent.order('id asc').each do |reading_event|
      if previous_read.present?
        previous_read.update_attribute(
          :seconds_until_next_read,
          reading_event.created_at.to_i - previous_read.created_at.to_i
        )
      end

      puts previous_read.attributes rescue nil
      previous_read = reading_event
    end
  end
end
