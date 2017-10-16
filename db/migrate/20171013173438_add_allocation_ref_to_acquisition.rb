class AddAllocationRefToAcquisition < ActiveRecord::Migration
  def change
    add_reference :acquisitions, :allocation, index: true, foreign_key: true
  end
end
