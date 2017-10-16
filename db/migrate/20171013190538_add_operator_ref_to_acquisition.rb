class AddOperatorRefToAcquisition < ActiveRecord::Migration
  def change
    add_reference :acquisitions, :operator, index: true, foreign_key: true
  end
end
