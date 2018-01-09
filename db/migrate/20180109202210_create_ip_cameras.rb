class CreateIpCameras < ActiveRecord::Migration
  def change
    create_table :ip_cameras do |t|

      t.timestamps null: false
    end
  end
end
