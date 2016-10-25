FactoryGirl.define do
  factory :house do
    address Faker::Address.street_address
    city Faker::Address.city
    state Faker::Address.state
    zip_code Faker::Address.zip_code
    price Faker::Commerce.price
    operation 'S'
    description Faker::Lorem.paragraph
    customer
  end

  factory :invalid_house, parent: :house do
    address nil
  end
end
