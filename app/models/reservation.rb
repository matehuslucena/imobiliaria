class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :house

  delegate :name, to: :user, prefix: true

end
