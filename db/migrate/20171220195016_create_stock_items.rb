class CreateStockItems < ActiveRecord::Migration
  def change
    create_table :stock_items do |t|
      t.string :short_description
      t.text :long_description
      t.integer :stock

      t.timestamps null: false
    end
  end
end
