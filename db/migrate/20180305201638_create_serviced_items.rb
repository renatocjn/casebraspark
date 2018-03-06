class CreateServicedItems < ActiveRecord::Migration
  def change
    create_table :serviced_items do |t|
      t.references :item, index: true, foreign_key: true
      t.references :service, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
