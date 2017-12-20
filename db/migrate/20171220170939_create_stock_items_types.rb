class CreateStockItemsTypes < ActiveRecord::Migration
  def change
    create_table :stock_items_types do |t|
      t.string :description

      t.timestamps null: false
    end
  end
end
