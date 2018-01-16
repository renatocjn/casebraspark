class CreateHelpDevices < ActiveRecord::Migration
  def change
    create_table :help_devices do |t|
      t.string :type

      t.timestamps null: false
    end
  end
end
