class CreateReadingEvents < ActiveRecord::Migration
  def change
    create_table :reading_events do |t|
      t.integer :device_id
      t.integer :sensor_id
      t.decimal :first_read
      t.decimal :second_read
      t.decimal :read_difference

      t.timestamps null: false
    end
  end
end
