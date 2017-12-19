class AddCurrPlacementToItem < ActiveRecord::Migration
  def change
    add_reference :items, :placement, index: true, foreign_key: true
  end
end
