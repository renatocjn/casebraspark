class CreateStockItemCounts < ActiveRecord::Migration
  def change
    create_table :stock_item_counts do |t|
      t.references :stock_item, index: true, foreign_key: true
      t.references :placement, index: true, foreign_key: true
      t.integer :count

      t.timestamps null: false
    end
  end
end
