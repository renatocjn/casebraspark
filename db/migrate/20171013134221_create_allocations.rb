class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.text :reason

      t.timestamps null: false
    end
  end
end
