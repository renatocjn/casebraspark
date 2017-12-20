class CreateStockItems < ActiveRecord::Migration
  def change
    create_table :stock_items do |t|
      t.string :serial_number
      t.string :short_description
      t.text :long_description
      t.references :acquisition, index: true, foreign_key: true
      t.references :stock_item_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
