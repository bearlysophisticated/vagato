class FilterController < ApplicationController
  def filter
=begin
    @search = Filter.new(search_params)

    @search.attributes = search_params

    puts params
    s_start_date = params[:start_date]
    puts "start_date: #{s_start_date}"

    @search.start_date = s_start_date
=end

    params[:filter][:equipment_ids].delete_at(params[:filter][:equipment_ids].length-1) unless params[:filter][:equipment_ids].nil?
    params[:filter][:serviice_ids].delete_at(params[:filter][:serviice_ids].length-1) unless params[:filter][:serviice_ids].nil?

    params[:filter].delete(:start_date)    if params[:filter][:start_date].empty?
    params[:filter].delete(:end_date)      if params[:filter][:end_date].empty?
    params[:filter].delete(:capacity)      if params[:filter][:capacity].empty?
    params[:filter].delete(:equipment_ids) if params[:filter][:equipment_ids].empty?
    params[:filter].delete(:serviice_ids)  if params[:filter][:serviice_ids].empty?

    url = UrlHelper.build_parameterised_url('/rooms', params[:filter])

    puts params
    puts url

    redirect_to url
  end

  def type_cast_from_user(param)
    puts param
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def search_params
    params.require(:filter).permit(:start_date, :end_date, :smart) #, {equipment_ids: []}, {serviice_ids: []})
  end
end
