class DropItemTypeTable < ActiveRecord::Migration
  def change
    drop_table :item_types
  end
end
