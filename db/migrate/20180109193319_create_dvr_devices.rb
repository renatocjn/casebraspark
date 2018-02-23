class CreateDvrDevices < ActiveRecord::Migration
  def change
    create_table :dvr_devices do |t|
      t.integer :number_of_channels

      #t.timestamps null: false
    end
  end
end
