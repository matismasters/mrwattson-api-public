class ReadingEvent < ActiveRecord::Base
  validates :sensor_id, :first_read, :second_read, presence: true
  validates_associated :device

  belongs_to :device
  before_save :calculate_read_difference

  private
  def calculate_read_difference
    self.read_difference = second_read - first_read
  end
end
