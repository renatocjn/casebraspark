class AddUnitValueToStockItemGroup < ActiveRecord::Migration
  def change
    add_column :stock_item_groups, :unit_value, :double
  end
end
