class AddInvoiceToAcquisition < ActiveRecord::Migration
  def change
    add_column :acquisitions, :invoice_id, :string
    add_column :acquisitions, :invoice_filename, :string
    add_column :acquisitions, :invoice_content_size, :integer
    add_column :acquisitions, :invoice_content_type, :string
  end
end
