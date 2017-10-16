class CreateJoinTableAllocationItem < ActiveRecord::Migration
  def change
    create_join_table :allocations, :items do |t|
      t.index [:allocation_id, :item_id]
      t.index [:item_id, :allocation_id]
    end
  end
end
