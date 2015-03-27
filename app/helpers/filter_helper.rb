module FilterHelper
  def self.filter_rooms(params)
    rooms_by_date = Array.new
    rooms_by_city = Array.new
    rooms_by_equipment = Array.new
    rooms_by_serviice = Array.new
    rooms_by_capacity = Array.new
    filter_viewpoints = 0

    if params.has_key? :city
      rooms_by_city = Room.joins(:accommodation => [:address]).where('lower(addresses.city) = ?', params[:city].downcase)
      filter_viewpoints += 1
    end

    if params.has_key? :capacity
      rooms_by_capacity = Room.where(:capacity => params[:capacity])
      filter_viewpoints += 1
    end

    if params.has_key? :equipment_ids
      equipment_ids = params[:equipment_ids].split(',')

      Room.all.each do |room|
        re = room.equipments.where(id: equipment_ids)
        if re.length == equipment_ids.length
          rooms_by_equipment.push(room)
        end
      end

      filter_viewpoints += 1
    end


    if params.has_key? :serviice_ids
      serviice_ids = params[:serviice_ids].split(',')

      Accommodation.all.each do |accommodation|
        as = accommodation.serviices.where(id: serviice_ids)
        if as.length == serviice_ids.length
          rooms_by_serviice.concat(accommodation.rooms)
        end
      end

      filter_viewpoints += 1
    end


    if params.has_key?(:start_date) && params.has_key?(:end_date)
      Room.all.each do |room|
        if BookingsHelper.is_bookable(room, Date.strptime(params[:start_date], '%Y.%m.%d'), Date.strptime(params[:end_date], '%Y.%m.%d'))
          rooms_by_date.push(room)
        end
      end

      filter_viewpoints += 1
    end

    rooms_to_intersect = Array.new
    intersected_rooms_ids = Hash.new
    intersected_rooms = Array.new

    rooms_to_intersect.concat(rooms_by_city) unless rooms_by_city.empty?
    rooms_to_intersect.concat(rooms_by_capacity) unless rooms_by_capacity.empty?
    rooms_to_intersect.concat(rooms_by_serviice) unless rooms_by_serviice.empty?
    rooms_to_intersect.concat(rooms_by_equipment) unless rooms_by_equipment.empty?
    rooms_to_intersect.concat(rooms_by_date) unless rooms_by_date.empty?

    rooms_to_intersect.each do |room|
      if intersected_rooms_ids.has_key?(room.id)
        intersected_rooms_ids[room.id] += 1
      else
        intersected_rooms_ids[room.id] = 1
      end
    end

    intersected_rooms_ids.keys.each do |key|
      if intersected_rooms_ids[key] == filter_viewpoints
        intersected_rooms.push(Room.find(key))
      end
    end

    intersected_rooms #return
  end

  def filter_rooms(params)
    self.filter_rooms(params)
  end

end
