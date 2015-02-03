class AccommodationEquipmentsController < ApplicationController
  before_action :set_accommodation_equipment, only: [:show, :edit, :update, :destroy]

  # GET /accommodation_equipments
  # GET /accommodation_equipments.json
  def index
    @accommodation_equipments = AccommodationEquipment.all
  end

  # GET /accommodation_equipments/1
  # GET /accommodation_equipments/1.json
  def show
  end

  # GET /accommodation_equipments/new_owner
  def new
    @accommodation_equipment = AccommodationEquipment.new
  end

  # GET /accommodation_equipments/1/edit
  def edit
  end

  # POST /accommodation_equipments
  # POST /accommodation_equipments.json
  def create
    @accommodation_equipment = AccommodationEquipment.new(accommodation_equipment_params)

    respond_to do |format|
      if @accommodation_equipment.save
        format.html { redirect_to @accommodation_equipment, notice: 'Accommodation equipment was successfully created.' }
        format.json { render :show, status: :created, location: @accommodation_equipment }
      else
        format.html { render :new }
        format.json { render json: @accommodation_equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accommodation_equipments/1
  # PATCH/PUT /accommodation_equipments/1.json
  def update
    respond_to do |format|
      if @accommodation_equipment.update(accommodation_equipment_params)
        format.html { redirect_to @accommodation_equipment, notice: 'Accommodation equipment was successfully updated.' }
        format.json { render :show, status: :ok, location: @accommodation_equipment }
      else
        format.html { render :edit }
        format.json { render json: @accommodation_equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accommodation_equipments/1
  # DELETE /accommodation_equipments/1.json
  def destroy
    @accommodation_equipment.destroy
    respond_to do |format|
      format.html { redirect_to accommodation_equipments_url, notice: 'Accommodation equipment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accommodation_equipment
      @accommodation_equipment = AccommodationEquipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def accommodation_equipment_params
      params.require(:accommodation_equipment).permit(:accommodation_id, :equipment_id)
    end
end
