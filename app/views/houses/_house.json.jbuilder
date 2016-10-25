json.extract! house, :id, :address, :city, :state, :zip_code, :price, :type, :description, :customer_id, :created_at, :updated_at
json.url house_url(house, format: :json)