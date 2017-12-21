class SplitPlacementAssociationOnAllocationIntoOriginAndDestination < ActiveRecord::Migration
  def change
    rename_column :allocations, :placement_id, :destination_id
    add_reference :allocations, :origin, foreign_key: true, index: true
  end
end
