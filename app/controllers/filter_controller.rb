class FilterController < ApplicationController
  def filter
    base_url = params[:base_url]

    if base_url.nil?
      flash[:danger] = 'Valami hiba történt a szűrés/keresés közben'
      redirect_to '/rooms'
    else

      params[:filter][:equipment_ids].delete_at(params[:filter][:equipment_ids].length-1) unless params[:filter][:equipment_ids].nil?
      params[:filter][:serviice_ids].delete_at(params[:filter][:serviice_ids].length-1) unless params[:filter][:serviice_ids].nil?

      params[:filter].delete(:city) if params[:filter][:city].empty?
      params[:filter].delete(:start_date) if params[:filter][:start_date].empty?
      params[:filter].delete(:end_date) if params[:filter][:end_date].empty?
      params[:filter].delete(:equipment_ids) if params[:filter][:equipment_ids].empty?
      params[:filter].delete(:serviice_ids) if params[:filter][:serviice_ids].empty?

      if params[:filter][:filter] == 'fine'
        params[:filter].delete(:capacity) if params[:filter][:capacity].empty?
      elsif params[:filter][:filter] == 'smart'
        params[:filter][:close] = params[:close] if params.has_key?('close')
        params[:filter][:cheap] = params[:cheap] if params.has_key?('cheap')

        params[:filter].delete(:guests) if params[:filter][:guests].empty?
      end

      url = UrlHelper.build_parameterised_url(base_url, params[:filter])

      redirect_to url
    end
  end

  def type_cast_from_user(param)
    puts param
  end

  def smartfilter
    @filter = Filter.new

    @rooms = FilterHelper.filter_rooms(params).sort_by! { |id| }
    lowest_price = get_lowest_price(@rooms)
    @rooms = FilterHelper.prepare_for_lp_solving(@rooms, params[:start_date], params[:end_date])

    if params.has_key?(:cheap) && params.has_key?(:close)
      distances = GeoHelper.calculate_distances_per_bed(@rooms)
      @rooms = OptModelHelper.find_cheap_and_close_solution(@rooms, distances, params[:guests], lowest_price, get_nearest_distance(distances))
    elsif params.has_key? :cheap
      @rooms = OptModelHelper.find_cheap_solution(@rooms, params[:guests])
    elsif params.has_key? :close
      distances = GeoHelper.calculate_distances_per_bed(@rooms)
      @rooms = OptModelHelper.find_close_solution(@rooms, distances, params[:guests])
    else
      @rooms = Array.new
    end

    @map_hash = GeoHelper.create_map_hash_from(@rooms)
  end


  private
  def get_lowest_price(rooms)
    lpr = Float::INFINITY

    rooms.each do |r|
      if r.price.value_with_vat < lpr
        lpr = r.price.value_with_vat
      end
    end

    return lpr
  end

  def get_nearest_distance(distances)
    ndst = Float::INFINITY

    distances.each_value do |d|
      d.each_value do |e|
        if e < ndst && e != 0.0
          ndst = e
        end
      end
    end

    return ndst
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def search_params
    params.require(:filter).permit(:start_date, :end_date, :smart) #, {equipment_ids: []}, {serviice_ids: []})
  end
end
