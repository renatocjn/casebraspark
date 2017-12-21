class CreateStockItemGroups < ActiveRecord::Migration
  def change
    create_table :stock_item_groups do |t|
      t.references :stock_item, index: true, foreign_key: true
      t.integer :quantity
      t.references :allocation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
