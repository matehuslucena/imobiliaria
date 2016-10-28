class House < ActiveRecord::Base
  belongs_to :user
  belongs_to :operation

  validates :address, :city, :state, :zip_code, :price, :operation, :description, :user, presence: true

  delegate :name, to: :operation, prefix: true
  delegate :name, to: :user, prefix: true
end
