class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.text :description

      t.timestamps null: false
    end
  end
end
