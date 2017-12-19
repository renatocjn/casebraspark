class RemoveAttrFromItem < ActiveRecord::Migration
  def change
    remove_column :items, :long_description, :string
    remove_column :items, :item_type_id, :string
  end
end
