class CreateComputers < ActiveRecord::Migration
  def change
    create_table :computers do |t|
      t.string :processor
      t.string :memory
      t.string :harddrive

      t.timestamps null: false
    end
  end
end
