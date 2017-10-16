class AddSupplierToAcquisitions < ActiveRecord::Migration
  def change
    add_column :acquisitions, :supplier, :string
  end
end
