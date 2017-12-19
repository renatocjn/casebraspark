class AddAllocationRefToOperator < ActiveRecord::Migration
  def change
    add_reference :operators, :allocation
  end
end
