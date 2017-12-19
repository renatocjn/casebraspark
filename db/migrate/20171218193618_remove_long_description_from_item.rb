class RemoveLongDescriptionFromItem < ActiveRecord::Migration
  def change
    remove_column :items, :longDescription
  end
end
