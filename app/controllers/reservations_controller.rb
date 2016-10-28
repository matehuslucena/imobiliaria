class ReservationsController < ApplicationController
  authorize_resource

  def index
    @reservations = Reservation.all.accessible_by(current_ability, :read)
  end

  def create
    reservation = Reservation.new(user_id: current_user.id, house_id: params[:house_id])

    if reservation.save
      respond_to do |format|
        format.html { redirect_to houses_path, notice: 'House was successfully reserved.' }
        format.json { render :index, status: :created, location: @house }
      end
    end
  end

  def destroy
    reservation = Reservation.find_by(user_id: current_user.id, house_id: params[:house_id])
    reservation.destroy

    respond_to do |format|
      format.html { redirect_to houses_path, notice: 'Reservation was successfully cancelled.' }
      format.json { head :no_content }
    end
  end
end
