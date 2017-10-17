class AddAdminAttributeToOperator < ActiveRecord::Migration
  def change
    add_column :operators, :isAdmin, :boolean
  end
end
