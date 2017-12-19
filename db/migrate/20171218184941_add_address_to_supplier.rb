class AddAddressToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :address, :string
  end
end
