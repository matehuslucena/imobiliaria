class House < ActiveRecord::Base
  belongs_to :customer

  delegate :full_name, to: :customer, prefix: true
end
