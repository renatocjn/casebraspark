class AddPrinterAttributesToItem < ActiveRecord::Migration
  def change
    add_column :items, :laser, :boolean
    add_column :items, :color, :boolean
    add_column :items, :scanner, :boolean
  end
end
