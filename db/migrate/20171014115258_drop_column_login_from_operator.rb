class DropColumnLoginFromOperator < ActiveRecord::Migration
  def change
    remove_column :operators, :login
  end
end
