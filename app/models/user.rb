class User < ActiveRecord::Base
  before_create :set_default_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [:admin, :agent, :customer]

  private
  def set_default_role
    self.role ||= 2
  end
end
