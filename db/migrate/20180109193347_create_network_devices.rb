class CreateNetworkDevices < ActiveRecord::Migration
  def change
    create_table :network_devices do |t|
      t.string :function

      t.timestamps null: false
    end
  end
end
