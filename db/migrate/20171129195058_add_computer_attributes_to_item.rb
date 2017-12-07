class AddComputerAttributesToItem < ActiveRecord::Migration
  def change
    add_column :items, :processor, :string
    add_column :items, :memory, :string
    add_column :items, :harddrive, :string
  end
end
