class AddScreenAttributesToItem < ActiveRecord::Migration
  def change
    add_column :items, :inches, :integer
  end
end
