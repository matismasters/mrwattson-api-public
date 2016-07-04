class CreateReadingEvents < ActiveRecord::Migration
  def change
    create_table :reading_events do |t|
      t.integer :device_id
      t.integer :sensor_id
      t.integer :first_read
      t.integer :second_read
      t.integer :read_difference

      t.timestamps null: false
    end
  end
end
