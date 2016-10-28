FactoryGirl.define do
  factory :operation do
    name "operation 1"
  end

  factory :invalid_operation, parent: :operation do
    name ''
  end
end
