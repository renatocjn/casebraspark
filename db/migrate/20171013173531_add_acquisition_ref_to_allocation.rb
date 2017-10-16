class AddAcquisitionRefToAllocation < ActiveRecord::Migration
  def change
    add_reference :allocations, :acquisition, index: true, foreign_key: true
  end
end
