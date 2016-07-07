class ReadingEvent < ActiveRecord::Base
  validates :device, :sensor_id, :first_read, :second_read, presence: true

  belongs_to :device
  before_save :calculate_read_difference

  scope :all_readings_from_last_7_days, proc {
    where('created_at >= ?', Time.now - 7.days).order(:created_at)
  }

  def to_watts
    second_read
  end

  def created_at
    TimestampsInMontevideoTimeZone.in_montevideo(attributes['created_at'])
  end

  def updated_at
    TimestampsInMontevideoTimeZone.in_montevideo(attributes['updated_at'])
  end

  private

  def calculate_read_difference
    self.read_difference = second_read - first_read
  end
end
