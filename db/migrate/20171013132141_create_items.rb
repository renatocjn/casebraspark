class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :shortDescription
      t.text :longDescription
      t.float :value

      t.timestamps null: false
    end
  end
end
