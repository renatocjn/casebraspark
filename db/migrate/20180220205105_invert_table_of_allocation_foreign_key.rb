class InvertTableOfAllocationForeignKey < ActiveRecord::Migration
  def change
    remove_column :allocations, :acquition_id
    add_reference :acquisitions, :allocation, index: true, foreign_key: true
  end
end
