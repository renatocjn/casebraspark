json.extract! supplier, :id, :name, :email, :phones, :other, :created_at, :updated_at
json.url supplier_url(supplier, format: :json)
