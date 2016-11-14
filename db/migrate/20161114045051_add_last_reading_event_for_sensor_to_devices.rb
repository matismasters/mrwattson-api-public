class AddLastReadingEventForSensorToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_reading_event_for_sensor_1, :integer
    add_column :devices, :last_reading_event_for_sensor_2, :integer
    add_column :devices, :last_reading_event_for_sensor_3, :integer
    add_column :devices, :last_reading_event_for_sensor_4, :integer
  end
end
