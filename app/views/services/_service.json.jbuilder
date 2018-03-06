json.extract! service, :id, :service_type, :description, :value, :file, :send_date, :recv_date, :created_at, :updated_at
json.url service_url(service, format: :json)
