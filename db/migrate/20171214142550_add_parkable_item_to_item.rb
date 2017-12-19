class AddParkableItemToItem < ActiveRecord::Migration
  def change
    add_column :items, :parkable_item_id, :integer
    add_column :items, :parkable_item_type, :string
  end
end
