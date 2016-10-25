FactoryGirl.define do
  factory :customer do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    phone Faker::PhoneNumber.phone_number
    document Faker::Number.number(10)
    address Faker::Address.street_address
  end
  
  factory :invalid_customer, parent: :customer do
    address nil
  end
end
