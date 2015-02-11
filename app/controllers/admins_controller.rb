class AdminsController < ApplicationController
  before_action :set_admin, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]

  def new
    @admin = Admin.new
    @admin.build_user
  end

  def create
    @admin = Admin.create(admin_params)

    if @admin.save
      redirect_to '/'
    else
      render :template => "admins/new"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
    @admins = Admin.all
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin
    @admin = Admin.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_params
    params.require(:admin).permit(:name, :phone,
                                  user_attributes: [:email, :password, :password_confirmation])
  end
end
