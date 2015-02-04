class AccommodationsController < ApplicationController
  before_action :set_accommodation, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index_owner, :index_admin, :new, :create, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]
  before_action :check_is_admin, only: [:index_admin]

  # GET /accommodations
  # GET /accommodations.json
  def index
    @accommodations = Accommodation.all
  end

  def index_owner
    @accommodations = Accommodation.where(owner: current_user.role)
  end

  def index_admin
    @accommodations = Accommodation.all
  end

  # GET /accommodations/1
  # GET /accommodations/1.json
  def show
    # @rooms = Accommodation.find(params[:id]).rooms
    @rooms = @accommodation.rooms
    @hash = Gmaps4rails.build_markers(@accommodation.address) do |address, marker|
      marker.lat address.latitude
      marker.lng address.longitude
    end
  end

  # GET /accommodations/new_owner
  def new
    @accommodation = Accommodation.new
    @accommodation.build_address
    @accommodation.build_categry
  end

  # GET /accommodations/1/edit
  def edit
  end

  # POST /accommodations
  # POST /accommodations.json
  def create
    @accommodation = Accommodation.new(accommodation_params)
    @accommodation.owner_id = current_user.role.id

    respond_to do |format|
      if @accommodation.save
        @accommodation.update_attributes(:code => @accommodation.id)
        format.html { redirect_to @accommodation, notice: 'Accommodation was successfully created.' }
        format.json { render :show, status: :created, location: @accommodation }
      else
        format.html { render :new }
        format.json { render json: @accommodation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accommodations/1
  # PATCH/PUT /accommodations/1.json
  def update
    respond_to do |format|
      if @accommodation.update(accommodation_params)
        format.html { redirect_to @accommodation, notice: 'Accommodation was successfully updated.' }
        format.json { render :show, status: :ok, location: @accommodation }
      else
        format.html { render :edit }
        format.json { render json: @accommodation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accommodations/1
  # DELETE /accommodations/1.json
  def destroy
    @accommodation.destroy
    respond_to do |format|
      format.html { redirect_to accommodations_url, notice: 'Accommodation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accommodation
      @accommodation = Accommodation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def accommodation_params
       params.require(:accommodation).permit(:name, :code, :description, :image, {serviice_ids: []}, 
        address_attributes: [:id, :country, :zip, :city, :address],
        categry_attributes: [:id, :name, :value])
    end

    def check_user
      unless current_user == @accommodation.owner.user || current_user.role.is_a?(Admin)
        redirect_to root_url, alert: "Nincs jogosultsaga!"
      end
    end

  def check_is_admin
    unless current_user.role.is_a?(Admin)
      redirect_to root_url, alert: "Nincs jogosultsaga!"
    end
  end
end
