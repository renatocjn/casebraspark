class CreateOperators < ActiveRecord::Migration
  def change
    create_table :operators do |t|
      t.string :name
      t.string :login
      t.string :email
      t.string :password_digest
      t.boolean :canAlocate
      t.boolean :canBuy

      t.timestamps null: false
    end
  end
end
