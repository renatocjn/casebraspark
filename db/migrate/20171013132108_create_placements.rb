class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.string :state
      t.string :city
      t.string :other
      t.text :contact
      t.text :address

      t.timestamps null: false
    end
  end
end
