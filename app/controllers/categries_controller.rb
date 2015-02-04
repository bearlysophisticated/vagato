class CategriesController < ApplicationController
  before_action :set_categry, only: [:show, :edit, :update, :destroy]

  # GET /categries
  # GET /categries.json
  def index
    @categries = Categry.all.sort_by(&:value)
  end

  # GET /categries/1
  # GET /categries/1.json
  def show
  end

  # GET /categries/new_owner
  def new
    @categry = Categry.new
  end

  # GET /categries/1/edit
  def edit
  end

  # POST /categries
  # POST /categries.json
  def create
    @categry = Categry.new(categry_params)

    respond_to do |format|
      if @categry.save
        format.html { redirect_to @categry, notice: 'Categry was successfully created.' }
        format.json { render :show, status: :created, location: @categry }
      else
        format.html { render :new }
        format.json { render json: @categry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categries/1
  # PATCH/PUT /categries/1.json
  def update
    respond_to do |format|
      if @categry.update(categry_params)
        format.html { redirect_to @categry, notice: 'Categry was successfully updated.' }
        format.json { render :show, status: :ok, location: @categry }
      else
        format.html { render :edit }
        format.json { render json: @categry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categries/1
  # DELETE /categries/1.json
  def destroy
    @categry.destroy
    respond_to do |format|
      format.html { redirect_to categries_url, notice: 'Categry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_categry
      @categry = Categry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def categry_params
      params.require(:categry).permit(:name, :code, :value, :accommodation_id)
    end
end
