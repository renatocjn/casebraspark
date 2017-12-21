json.extract! stock_item, :id, :short_description, :long_description, :stock, :created_at, :updated_at
json.url stock_item_url(stock_item, format: :json)
