class RemovePermissionsFromOperator < ActiveRecord::Migration
  def change
    remove_column :operators, :canAlocate, :string
    remove_column :operators, :canBuy, :string
  end
end
