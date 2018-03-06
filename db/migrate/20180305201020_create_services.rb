class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :service_type
      t.text :description
      t.float :value
      t.string :invoice_id
      t.string :invoice_filename
      t.string :invoice_content_size
      t.string :invoice_content_type
      t.date :send_date
      t.date :recv_date

      t.references :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
