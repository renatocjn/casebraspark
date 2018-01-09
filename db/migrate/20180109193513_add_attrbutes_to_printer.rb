class AddAttrbutesToPrinter < ActiveRecord::Migration
  def change
    add_column :printers, :connection, :string
    add_column :printers, :functions, :string
    add_column :printers, :paint, :string
  end
end
