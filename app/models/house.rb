class House < ActiveRecord::Base
  belongs_to :customer
  belongs_to :operation

  validates :address, :city, :state, :zip_code, :price, :operation, :description, :presence => true

  delegate :full_name, to: :customer, prefix: true
  delegate :name, to: :operation, prefix: true
end
