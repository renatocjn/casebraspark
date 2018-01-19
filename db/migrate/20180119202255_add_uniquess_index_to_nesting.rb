class AddUniquessIndexToNesting < ActiveRecord::Migration
  def change
    add_index :stock_item_groups, [:stock_item_id, :allocation_id], unique: true
  end
end
