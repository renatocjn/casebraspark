class AddBlockedColumnToOperator < ActiveRecord::Migration
  def change
    add_column :operators, :isBlocked, :boolean
  end
end
