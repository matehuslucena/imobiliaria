class Operation < ActiveRecord::Base
  has_many :houses

  validates :name, presence: true
end
