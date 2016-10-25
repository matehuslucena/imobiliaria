json.extract! customer, :id, :first_name, :last_name, :phone, :document, :address, :created_at, :updated_at
json.url customer_url(customer, format: :json)