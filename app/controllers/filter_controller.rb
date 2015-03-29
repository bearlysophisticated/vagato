class FilterController < ApplicationController
  def filter
    base_url = params[:base_url]

    if base_url.nil?
      flash[:danger] = 'Valami hiba történt a szűrés/keresés közben'
      redirect_to '/rooms'
    else

      params[:filter][:equipment_ids].delete_at(params[:filter][:equipment_ids].length-1) unless params[:filter][:equipment_ids].nil?
      params[:filter][:serviice_ids].delete_at(params[:filter][:serviice_ids].length-1) unless params[:filter][:serviice_ids].nil?

      if params[:city].empty?
        params.delete(:city)
      else
        params[:filter][:city] = params[:city]
      end
      if params[:start_date].empty?
        params.delete(:start_date)
      else
        params[:filter][:start_date] = params[:start_date]
      end
      if params[:end_date].empty?
        params.delete(:end_date)
      else
        params[:filter][:end_date] = params[:end_date]
      end

      params[:filter].delete(:equipment_ids) if params[:filter][:equipment_ids].empty?
      params[:filter].delete(:serviice_ids) if params[:filter][:serviice_ids].empty?

      if params[:filter][:filter] == 'fine'
        if params[:capacity].empty?
          params.delete(:capacity)
        else
          params[:filter][:capacity] = params[:capacity]
        end

      elsif params[:filter][:filter] == 'smart'
        params[:filter][:close] = params[:close] if params.has_key?('close')
        params[:filter][:cheap] = params[:cheap] if params.has_key?('cheap')

        if params[:guests].empty?
          params.delete(:guests)
        else
          params[:filter][:guests] = params[:guests]
        end
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
      @rooms = Array.new
    end

    @rooms.sort_by! { |r| r.accommodation.name }
    @map_hash = GeoHelper.create_map_hash_from(@rooms)
  end

end
