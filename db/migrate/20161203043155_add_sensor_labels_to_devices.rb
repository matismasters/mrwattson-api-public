class AddSensorLabelsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :sensor_1_label, :string
    add_column :devices, :sensor_2_label, :string
    add_column :devices, :sensor_3_label, :string
    add_column :devices, :sensor_4_label, :string
  end
end
