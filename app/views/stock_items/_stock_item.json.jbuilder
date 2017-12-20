json.extract! stock_item, :id, :serial_number, :short_description, :long_description, :acquisition_id, :stock_item_types_id, :created_at, :updated_at
json.url stock_item_url(stock_item, format: :json)
