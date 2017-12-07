class AddTypeToItem < ActiveRecord::Migration
  def change
    add_column :items, :type, :string
    remove_column :items, :item_type_id
  end
end
