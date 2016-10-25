class Customer < ActiveRecord::Base
  has_many :houses

  validates :first_name, :last_name, :phone, :document, :address, :presence => true

  def full_name
    self.first_name + ' ' + self.last_name
  end
end
