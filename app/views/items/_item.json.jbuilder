json.extract! item, :id, :plate, :item_type, :brand, :model, :serial, :longDescription, :value, :created_at, :updated_at
json.url item_url(item, format: :json)
