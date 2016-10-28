class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
     can :manage, :all

    elsif user.agent?
      can :manage, House
      cannot [:destroy, :update], House
      can :manage, Reservation

    elsif user.customer?
      can [:update, :destroy, :create, :show], House, user_id: user.id
      can :read, House
      can :customer_houses, House, user_id: user.id
      can :manage, Reservation, user_id: user.id
    end
  end
end
