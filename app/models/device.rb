class Device < ActiveRecord::Base
  serialize :configuration, Hash

  has_many :reading_events
  has_many :device_notifications

  before_create :basic_configuration

  def sensors_last_reads
    {
      sensors_last_reads: (0..4).map do |index|
        read = reading_events
          .where('sensor_id = ?', index)
          .order('created_at desc')
          .limit(1)
          .first

        read ? read.to_watts : 0
      end
    }
  end

  private

  def basic_configuration
    self.configuration = {
      sensor_1_active: true,
      sensor_2_active: true,
      sensor_3_active: true,
      sensor_4_active: true
    }.merge(self.configuration)
  end
end
