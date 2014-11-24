class RoomEquipmentsController < ApplicationController
  before_action :set_room_equipment, only: [:show, :edit, :update, :destroy]

  # GET /room_equipments
  # GET /room_equipments.json
  def index
    @room_equipments = RoomEquipment.all
  end

  # GET /room_equipments/1
  # GET /room_equipments/1.json
  def show
  end

  # GET /room_equipments/new
  def new
    @room_equipment = RoomEquipment.new
  end

  # GET /room_equipments/1/edit
  def edit
  end

  # POST /room_equipments
  # POST /room_equipments.json
  def create
    @room_equipment = RoomEquipment.new(room_equipment_params)

    respond_to do |format|
      if @room_equipment.save
        format.html { redirect_to @room_equipment, notice: 'Room equipment was successfully created.' }
        format.json { render :show, status: :created, location: @room_equipment }
      else
        format.html { render :new }
        format.json { render json: @room_equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /room_equipments/1
  # PATCH/PUT /room_equipments/1.json
  def update
    respond_to do |format|
      if @room_equipment.update(room_equipment_params)
        format.html { redirect_to @room_equipment, notice: 'Room equipment was successfully updated.' }
        format.json { render :show, status: :ok, location: @room_equipment }
      else
        format.html { render :edit }
        format.json { render json: @room_equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_equipments/1
  # DELETE /room_equipments/1.json
  def destroy
    @room_equipment.destroy
    respond_to do |format|
      format.html { redirect_to room_equipments_url, notice: 'Room equipment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room_equipment
      @room_equipment = RoomEquipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_equipment_params
      params.require(:room_equipment).permit(:room_id, :equipment_id)
    end
end
