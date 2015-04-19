module FilterHelper

  def self.get_rooms_by_date(start_date, end_date)
    rooms_by_date = Array.new
    unless start_date.nil? && end_date.nil?
      Room.all.each do |room|
        if BookingsHelper.is_bookable(room, Date.strptime(start_date, '%Y.%m.%d'), Date.strptime(end_date, '%Y.%m.%d'))
          rooms_by_date.push(room)
        end
      end
    end
    return rooms_by_date
  end

  def self.get_rooms_by_city(city)
    rooms_by_city = Array.new
    unless city.nil?
      rooms_by_city = Room.joins(:accommodation => [:address]).where('lower(addresses.city) = ?', city.downcase)
    end
    return rooms_by_city
  end

  def self.get_rooms_by_equipment(equipment_ids)
    rooms_by_equipment = Array.new
    unless equipment_ids.nil?
      equipment_ids =equipment_ids.split(',')
      Room.all.each do |room|
        re = room.equipments.where(id: equipment_ids)
        if re.length == equipment_ids.length
          rooms_by_equipment.push(room)
        end
      end
    end
    return rooms_by_equipment
  end

  def self.get_rooms_by_serviice(serviice_ids)
    rooms_by_serviice = Array.new
    unless serviice_ids.nil?
      serviice_ids = serviice_ids.split(',')
      Accommodation.all.each do |accommodation|
        as = accommodation.serviices.where(id: serviice_ids)
        if as.length == serviice_ids.length
          rooms_by_serviice.concat(accommodation.rooms)
        end
      end
    end
    return rooms_by_serviice
  end

  def self.get_rooms_by_capacity(params)
    rooms_by_capacity = Array.new

    if params.has_key? :capacity
      rooms_by_capacity = Room.where(:capacity => params[:capacity])
    else
      if params[:one_bed] == '1'
        rooms_by_capacity.concat(Room.where(:capacity => 1))
      end
      if params[:two_bed] == '1'
        rooms_by_capacity.concat(Room.where(:capacity => 2))
      end
      if params[:three_bed] == '1'
        rooms_by_capacity.concat(Room.where(:capacity => 3))
      end
      if params[:four_or_more_bed] == '1'
        rooms_by_capacity.concat(Room.where('capacity >= ?', 4))
      end
    end
    return rooms_by_capacity
  end

  def self.get_filter_viewpoints(params)
    filter_viewpoints = 0
    filter_viewpoints += 1 if params.has_key?(:start_date) && params.has_key?(:end_date)
    filter_viewpoints += 1 if params.has_key? :city
    filter_viewpoints += 1 if params.has_key? :equipment_ids
    filter_viewpoints += 1 if params.has_key? :serviice_ids
    filter_viewpoints += 1 if params.has_key?(:capacity) || params.has_key?(:one_bed) || params.has_key?(:two_bed) || params.has_key?(:three_bed) || params.has_key?(:four_or_more_bed)
    return filter_viewpoints
  end

  def self.combine_filters(rooms_by_date, rooms_by_city, rooms_by_equipment, rooms_by_serviice, rooms_by_capacity, filter_viewpoints)
    rooms = Room.all
    intersected_rooms_ids = Hash.new
    filtered_rooms = Array.new

    rooms.concat(rooms_by_city) unless rooms_by_city.empty?
    rooms.concat(rooms_by_capacity) unless rooms_by_capacity.empty?
    rooms.concat(rooms_by_serviice) unless rooms_by_serviice.empty?
    rooms.concat(rooms_by_equipment) unless rooms_by_equipment.empty?
    rooms.concat(rooms_by_date) unless rooms_by_date.empty?

    rooms.each do |room|
      if intersected_rooms_ids.has_key?(room.id)
        intersected_rooms_ids[room.id] += 1
      else
        intersected_rooms_ids[room.id] = 1
      end
    end

    intersected_rooms_ids.keys.each do |key|
      if intersected_rooms_ids[key] == filter_viewpoints+1
        filtered_rooms.push(Room.find(key))
      end
    end

    return filtered_rooms
  end

  def self.filter_rooms(params)
    rooms_by_date = get_rooms_by_date(params[:start_date], params[:end_date])
    rooms_by_city = get_rooms_by_city(params[:city])
    rooms_by_equipment = get_rooms_by_equipment(params[:equipment_ids])
    rooms_by_serviice = get_rooms_by_serviice(params[:serviice_ids])
    rooms_by_capacity = get_rooms_by_capacity(params)
    filter_viewpoints = get_filter_viewpoints(params)

    combine_filters(rooms_by_date, rooms_by_city, rooms_by_equipment, rooms_by_serviice, rooms_by_capacity, filter_viewpoints)
  end

  def filter_rooms(params)
    self.filter_rooms(params)
  end


  def self.prepare_rooms_for_smartfilter(params)
    rooms = self.filter_rooms(params).sort_by! { |r| r.id }
    prepared_rooms = Hash.new

    rooms.each do |room|
      if params[:start_date].nil? && params[:end_date].nil?
        i = 1
        room.num_of_this.times do
          prepared_rooms["R#{room.id}_#{i}"] = room
          i+=1
        end
      else
        i = 1
        BookingsHelper.get_free_rooms_count(room, params[:start_date], params[:end_date]).times do
          prepared_rooms["R#{room.id}_#{i}"] = room
          i+=1
        end
      end
    end

    return prepared_rooms
  end

  def prepare_rooms_for_smartfilter(params)
    return self.prepare_rooms_for_smartfilter(params)
  end
end
