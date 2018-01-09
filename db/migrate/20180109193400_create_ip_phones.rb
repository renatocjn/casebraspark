class CreateIpPhones < ActiveRecord::Migration
  def change
    create_table :ip_phones do |t|

      t.timestamps null: false
    end
  end
end
