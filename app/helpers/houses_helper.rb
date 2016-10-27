module HousesHelper
  def user_has_reserved?(user_id, house_id)
    Reservation.exists?(user_id: user_id, house_id: house_id)
  end
end
