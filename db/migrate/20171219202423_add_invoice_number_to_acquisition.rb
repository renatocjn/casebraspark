class AddInvoiceNumberToAcquisition < ActiveRecord::Migration
  def change
    add_column :acquisitions, :invoice_number, :string
  end
end
