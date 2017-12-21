class RemoveStockFromStockItems < ActiveRecord::Migration
  def change
    remove_column :stock_items, :stock
  end
end
