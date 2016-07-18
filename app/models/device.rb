class Device < ActiveRecord::Base
  has_many :reading_events
  has_many :device_notifications

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
end
