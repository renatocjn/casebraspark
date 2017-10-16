class AddPlacementRefToAllocation < ActiveRecord::Migration
  def change
    add_reference :allocations, :placement, index: true, foreign_key: true
  end
end
