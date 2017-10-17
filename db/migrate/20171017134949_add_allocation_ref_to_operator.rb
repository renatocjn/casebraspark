class AddAllocationRefToOperator < ActiveRecord::Migration
  def change
    add_column :operators, :allocation, :reference
  end
end
