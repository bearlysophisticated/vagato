class OwnersController < ApplicationController
  before_action :set_owner, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]


  # GET /accommodations/new_owner
  def new
    @owner = Owner.new
    @owner.build_user
  end

  # GET /accommodations/1/edit
  def edit
  end

  # POST /accommodations
  # POST /accommodations.json
  def create
    @owner = Owner.create(owner_params)
    if @owner.save
      redirect_to '/'
    else
      render :template => "owners/new"
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
  def set_owner
    @guest = Owner.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def owner_params
    params.require(:owner).permit(:name,
                                  user_attributes: [:email, :password, :password_confirmation])
  end
end
