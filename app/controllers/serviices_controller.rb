class ServiicesController < ApplicationController
  before_action :set_serviice, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @serviices = Serviice.all
    respond_with(@serviices)
  end

  def show
    respond_with(@serviice)
  end

  def new
    @serviice = Serviice.new
    respond_with(@serviice)
  end

  def edit
  end

  def create
    @serviice = Serviice.new(serviice_params)
    @serviice.save
    respond_with(@serviice)
  end

  def update
    @serviice.update(serviice_params)
    respond_with(@serviice)
  end

  def destroy
    @serviice.destroy
    respond_with(@serviice)
  end

  private
    def set_serviice
      @serviice = Serviice.find(params[:id])
    end

    def serviice_params
      params.require(:serviice).permit(:name, :code)
    end
end
