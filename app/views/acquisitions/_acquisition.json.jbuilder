json.extract! acquisition, :id, :reason, :created_at, :updated_at, include => [:allocation, :items, :operator]
json.url acquisition_url(acquisition, format: :json)
