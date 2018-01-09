class AddDateToAllocation < ActiveRecord::Migration
  def change
    add_column :allocations, :date, :date
  end
end
