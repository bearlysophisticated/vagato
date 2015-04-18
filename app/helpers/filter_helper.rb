module FilterHelper
  def self.filter_rooms(params)
    rooms = Room.all
    rooms_by_date = Array.new
    rooms_by_city = Array.new
    rooms_by_equipment = Array.new
    rooms_by_serviice = Array.new
    rooms_by_capacity = Array.new
    filter_viewpoints = 1

    puts params

    if params.has_key? :city
      rooms_by_city = Room.joins(:accommodation => [:address]).where('lower(addresses.city) = ?', params[:city].downcase)
      filter_viewpoints += 1
    end

    if params.has_key? :capacity
      rooms_by_capacity = Room.where(:capacity => params[:capacity])
      filter_viewpoints += 1
    else
      is_filtering_by_beds = false

      if params[:one_bed] == '1'
        rooms_by_capacity.concat(Room.where(:capacity => 1))
        is_filtering_by_beds = true
      end

      if params[:two_bed] == '1'
        rooms_by_capacity.concat(Room.where(:capacity => 2))
        is_filtering_by_beds = true
      end

      if params[:three_bed] == '1'
        rooms_by_capacity.concat(Room.where(:capacity => 3))
        is_filtering_by_beds = true
      end

      if params[:four_or_more_bed] == '1'
        rooms_by_capacity.concat(Room.where('capacity >= ?', 4))
        is_filtering_by_beds = true
      end

      filter_viewpoints += 1 if is_filtering_by_beds
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

    intersected_rooms_ids = Hash.new
    intersected_rooms = Array.new

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
      if intersected_rooms_ids[key] == filter_viewpoints
        intersected_rooms.push(Room.find(key))
      end
    end

    intersected_rooms #return
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

    puts prepared_rooms.to_s
    return prepared_rooms
  end

  def prepare_rooms_for_smartfilter(params)
    return self.prepare_rooms_for_smartfilter(params)
  end
end
