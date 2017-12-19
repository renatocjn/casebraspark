class CreateScreens < ActiveRecord::Migration
  def change
    create_table :screens do |t|
      t.integer :inches

      t.timestamps null: false
    end
  end
end
