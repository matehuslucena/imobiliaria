class HousesController < ApplicationController
  load_and_authorize_resource

  before_action :set_house, only: [:show, :edit, :update, :destroy]

  def index
    @houses = House.where.not(user_id: current_user.id ) if current_user.customer?
    @houses = House.all if current_user.agent? || current_user.admin?
  end

  def show
  end

  def new
    @house = House.new
  end

  def edit
  end

  def create
    @house = House.new(house_params)
    @house.user = current_user if current_user.customer?

    respond_to do |format|
      if @house.save
        format.html { redirect_to @house, notice: 'House was successfully created.' }
        format.json { render :show, status: :created, location: @house }
      else
        format.html { render :new }
        format.json { render json: @house.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @house.update(house_params)
        format.html { redirect_to @house, notice: 'House was successfully updated.' }
        format.json { render :show, status: :ok, location: @house }
      else
        format.html { render :edit }
        format.json { render json: @house.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @house.destroy
    respond_to do |format|
      format.html { redirect_to houses_url, notice: 'House was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def customer_houses
    @houses = House.all.accessible_by(current_ability, :customer_houses)
  end

  private
    def set_house
      @house = House.find(params[:id])
    end

    def house_params
      params.require(:house).permit(:address, :city, :state, :zip_code, :price, :operation_id, :description, :user_id)
    end
end
