class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :sql_query
      t.string :frequency
      t.string :title
      t.string :body
      t.string :tokens

      t.timestamps null: false
    end
  end
end
