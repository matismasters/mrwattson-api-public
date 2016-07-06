class ReadingEvent < ActiveRecord::Base
  include TimestampsInMontevideoTimeZone

  validates :device, :sensor_id, :first_read, :second_read, presence: true

  belongs_to :device
  before_save :calculate_read_difference

  def to_watts
    second_read
  end

  private

  def calculate_read_difference
    self.read_difference = second_read - first_read
  end
end
