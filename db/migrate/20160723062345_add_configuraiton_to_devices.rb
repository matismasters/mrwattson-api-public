class AddConfiguraitonToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :configuration, :string
  end
end
