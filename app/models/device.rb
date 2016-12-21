class Device < ActiveRecord::Base
  serialize :configuration, Hash

  has_many :reading_events
  has_many :device_notifications

  before_create :basic_configuration
  before_save :update_cached_sensor_labels

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

  def last_reading_events_reads
    [0] + last_reading_events.map(&:to_watts)
  end

  def merge_configuration(new_configuration)
    new_configuration.each do |key, value|
      self.configuration[key.to_sym] = value
    end
  end

  def update_this_month_notifications(notification)
    clean_this_month_notifications

    unless this_month_notifications.match notification.name
      notification_names = this_month_notifications.split(',')
      notification_names << notification.name

      self.this_month_notifications = notification_names.join(',')
    end

    save
  end

  def clean_this_month_notifications
    month_number = Date.today.month
    if this_month != month_number
      self.this_month =  month_number
      self.this_month_notifications = ''
    end
  end

  def clean_this_month_notifications!
    clean_this_month_notifications
    save
  end

  private

  def last_reading_events_ids
    (1..4).map do |sensor_id|
      send(:"last_reading_event_for_sensor_#{sensor_id}")
    end.compact
  end

  def last_reading_events
    ReadingEvent.where(id: last_reading_events_ids).order(:sensor_id)
  end

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

  def update_cached_sensor_labels
    self.sensor_1_label = self.configuration[:sensor_1_label]
    self.sensor_2_label = self.configuration[:sensor_2_label]
    self.sensor_3_label = self.configuration[:sensor_3_label]
    self.sensor_4_label = self.configuration[:sensor_4_label]
  end
end
