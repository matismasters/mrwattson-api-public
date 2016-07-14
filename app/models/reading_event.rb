class ReadingEvent < ActiveRecord::Base
  validates :device, :sensor_id, :start_read, :end_read, presence: true

  belongs_to :device
  before_save :calculate_read_difference
  before_save :calculate_seconds_until_next_reading_event

  scope :all_readings_from_last_7_days, proc {
    where('created_at >= ?', Time.now - 7.days).order(:created_at)
  }

  def to_watts
    end_read
  end

  def created_at
    TimestampsInMontevideoTimeZone.in_montevideo(attributes['created_at'])
  end

  def updated_at
    TimestampsInMontevideoTimeZone.in_montevideo(attributes['updated_at'])
  end

  def calculate_seconds_until_next_reading_event
    last_reading_event = last_reading_event_for_device
    if last_reading_event.present?
      last_reading_event.update_column(
        :seconds_until_next_read,
        Time.now.to_i - last_reading_event.created_at.to_i
      )
    end
  end

  # Making sure the TimeZones are not used using attributes
  def last_reading_event_for_device
    device.reading_events
      .where('created_at < ? AND sensor_id = ?', Time.now, sensor_id)
      .order('created_at desc')
      .limit(1)
      .first
  end

  private

  def calculate_read_difference
    self.read_difference = end_read - start_read
  end
end
