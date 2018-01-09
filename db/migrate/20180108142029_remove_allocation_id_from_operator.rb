class RemoveAllocationIdFromOperator < ActiveRecord::Migration
  def change
    remove_column :operators, :allocation_id
  end
end
