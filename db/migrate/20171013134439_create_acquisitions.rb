class CreateAcquisitions < ActiveRecord::Migration
  def change
    create_table :acquisitions do |t|
      t.text :reason

      t.timestamps null: false
    end
  end
end
