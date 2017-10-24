class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :plate
      t.string :brand
      t.string :model
      t.string :serial
      t.text :longDescription
      t.float :value

      t.timestamps null: false
    end
  end
end
