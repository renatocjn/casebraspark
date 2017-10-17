class DropColumnAllocationFromAcquisiton < ActiveRecord::Migration
  def change
    remove_column :acquisitions, :allocation_id
  end
end
