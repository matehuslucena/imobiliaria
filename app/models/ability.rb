class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here.
    user ||= User.new # guest user (not logged in)
    if user.admin?
     can :manage, :all

    elsif user.agent?
      can :manage, House
      can :manage, Reservation

    elsif user.customer?
      can :manage, House, user_id: user.id
      can :manage, Reservation, user_id: user.id
    end
  end
end
