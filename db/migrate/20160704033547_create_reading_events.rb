class CreateReadingEvents < ActiveRecord::Migration
  def change
    create_table :reading_events do |table|
      table.integer :device_id
      table.integer :sensor_id
      table.decimal :first_read
      table.decimal :second_read
      table.decimal :read_difference

      table.timestamps null: false
    end
  end
end
