class UserController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Successfully created User."
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation, :role)
    end
end
