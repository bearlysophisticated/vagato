class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  #before_action :check_user, only: [:new_owner, :create, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @cart = CartHelper.get_cart_for(current_user.role)
  end

  # GET /rooms/new_owner
  def new
    @room = Room.new
    @room.accommodation_id = params[:acc_id]
    price = @room.build_price

    price.currency = PricesHelper.default_currency
    price.vat = PricesHelper.default_vat
    price.ifa = PricesHelper.default_ifa
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to "/accommodations/#{@room.accommodation.id}/edit", notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to "/accommodations/#{@room.accommodation.id}/edit", notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :code, :accommodation_id, :description, :capacity, :num_of_this, :image, {equipment_ids: []},
        price_attributes: [:id, :value])
    end

    def check_user
      if params[:acc_id].nil?
        accommodation = Accommodation.find(params[:room][:accommodation_id])
      else
        accommodation = Accommodation.find(params[:acc_id])
      end

      if current_user != accommodation.user
        redirect_to root_url, alert: "Nincs jogosultsaga!"
      end
    end

end
