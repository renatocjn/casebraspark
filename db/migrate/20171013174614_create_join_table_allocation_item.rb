class CreateJoinTableAllocationItem < ActiveRecord::Migration
  def change
    create_table :allocations_items do |t|
      t.integer :allocation_id
      t.integer :item_id
    end
  end
end
