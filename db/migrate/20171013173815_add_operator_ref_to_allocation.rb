class AddOperatorRefToAllocation < ActiveRecord::Migration
  def change
    add_reference :allocations, :operator, index: true, foreign_key: true
  end
end
