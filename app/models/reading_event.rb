class ReadingEvent < ActiveRecord::Base
  validates :device, :sensor_id, :start_read, :end_read, presence: true
  validate :big_read_on_disabled_sensor

  belongs_to :device
  before_save :calculate_read_difference
  before_create :calculate_seconds_since_last_reading_event

  scope :all_readings_from_last_7_days, proc {
    where('created_at >= ?', Time.now - 7.days).order(:created_at)
  }

  def to_watts
    end_read
  end

  def created_at_montevideo
    TimestampsInMontevideoTimeZone.in_montevideo(attributes['created_at'])
  end

  def updated_at_montevideo
    TimestampsInMontevideoTimeZone.in_montevideo(attributes['updated_at'])
  end

  def calculate_seconds_since_last_reading_event
    last_reading_event = last_reading_event_for_device
    if last_reading_event.present?
      last_reading_event.update_attribute(
        :seconds_until_next_read,
        created_at_or_now.to_i - last_reading_event.created_at.to_i
      )
    end
  end

  def last_reading_event_for_device
    device.reading_events.where(
      'created_at < ? AND sensor_id = ? AND id != ?',
      created_at_or_now,
      sensor_id,
      (id || 0)
    )
    .order('created_at desc')
    .limit(1)
    .first
  end

  def created_at_or_now
    created = attributes['created_at']
    created ? created : Time.now
  end

  def self.recalculate_seconds_between_all_reading_events
    order('id asc').each(&:calculate_seconds_since_last_reading_event)
  end

  private

  def big_read_on_disabled_sensor
    if end_read >= 5000 && device.sensor_disabled?(sensor_id)
      errors.add(:configuration, "sensor #{sensor_id} is disabled")
    end
  end

  def calculate_read_difference
    self.read_difference = end_read - start_read
  end
end
