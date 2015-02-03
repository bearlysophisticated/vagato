class GuestsController < ApplicationController
  before_action :set_guest, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]


  # GET /accommodations/new_owner
  def new
    @guest = Guest.new
    @guest.build_user
    @guest.build_address
  end

  # GET /accommodations/1/edit
  def edit
  end

  # POST /accommodations
  # POST /accommodations.json
  def create
    @guest = Guest.new(guest_params)
    puts guest_params
    if @guest.save
      redirect_to '/'
    else
      render :template => "guests/new"
    end
  end

  # PATCH/PUT /accommodations/1
  # PATCH/PUT /accommodations/1.json
  def update
  end

  # DELETE /accommodations/1
  # DELETE /accommodations/1.json
  def destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_guest
    @guest = Guest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def guest_params
    params.require(:guest).permit(:name, :phone, :day_of_birth,
                                  address_attributes: [:id, :country, :zip, :city, :address],
                                  user_attributes: [:email, :password, :password_confirmation])
  end
end
