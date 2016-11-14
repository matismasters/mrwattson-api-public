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

  def sensor_disabled?(sensor_id)
    configuration[:"sensor_#{sensor_id}_active"] == false
  end

  def active_opportunities
    LatestDeviceNotification.active_opportunities_for_device(id)
  end

  def last_reading_event_for_sensor(sensor_id)
    reading_event_id = send(:"last_reading_event_for_sensor_#{sensor_id}")
    ReadingEvent.find(reading_event_id) unless reading_event_id.blank?
  end

  private

  def basic_configuration
    self.configuration = {
      sensor_1_active: true,
      sensor_1_label: '',
      sensor_2_active: true,
      sensor_2_label: '',
      sensor_3_active: true,
      sensor_3_label: '',
      sensor_4_active: true,
      sensor_4_label: true
    }.merge(self.configuration)
  end
end
