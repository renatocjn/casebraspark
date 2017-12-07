class AddDischargeToItem < ActiveRecord::Migration
  def change
    add_column :items, :isDischarged, :boolean
    add_column :items, :dischargeDescription, :text
  end
end
