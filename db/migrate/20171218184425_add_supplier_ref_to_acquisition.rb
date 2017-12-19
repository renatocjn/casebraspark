class AddSupplierRefToAcquisition < ActiveRecord::Migration
  def change
    remove_column :acquisitions, :supplier
    add_reference :acquisitions, :supplier, index: true, foreign_key: true
  end
end
