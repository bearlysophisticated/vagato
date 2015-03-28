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

    # @rooms = FilterHelper.filter_rooms(params).sort_by! { |r| r.id }
    @rooms = FilterHelper.prepare_rooms_for_smartfilter(params)

    if params.has_key?(:cheap) && params.has_key?(:close)
      distances = GeoHelper.calculate_distances_per_room(@rooms)
      @rooms = OptDataHelper.find_cheap_and_close_solution(@rooms, distances, params[:guests])
    elsif params.has_key? :cheap
      @rooms = OptDataHelper.find_cheap_solution(@rooms, params[:guests])
    elsif params.has_key? :close
      distances = GeoHelper.calculate_distances_per_room(@rooms)
      @rooms = OptDataHelper.find_close_solution(@rooms, distances, params[:guests])
    else
      @rooms = Hash.new
    end

    @map_hash = GeoHelper.create_map_hash_from(@rooms)
  end

end
