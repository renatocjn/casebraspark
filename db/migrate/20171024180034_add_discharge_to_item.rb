class AddDischargeToItem < ActiveRecord::Migration
  def change
    add_column :items, :isDischarged, :string
    add_column :items, :dischargeDescription, :text
  end
end
