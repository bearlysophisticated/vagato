module GeoHelper

  def self.calculate_distances_per_room(rooms)
    distances = Array.new
    rooms.each_value do |room|
      sub_distances = Array.new
      rooms.each_value do |moor|
        sub_distances.push(moor.accommodation.address.distance_to(room.accommodation.address)*1.609344)
      end
      distances.push(sub_distances)
    end

    return distances
  end

  def calculate_distances_per_room(rooms)
    return self.calculate_distances_per_room(rooms)
  end


  def self.calculate_distances_per_bed(rooms)
    distances = Hash.new

    rooms.each_pair do |key, room|
      sub_distances = Hash.new
      start = room.accommodation.address

      rooms.each_pair do |subkey, subroom|
        destination = subroom.accommodation.address
        distance = destination.distance_to(start, :km)
        sub_distances[subkey] = distance
      end

      distances[key] = sub_distances
    end

    return distances
  end

  def calculate_distances_per_bed(rooms)
    return self.calculate_distances_per_bed(rooms)
  end


  def self.create_map_hash_from(rooms)
    accommodations = Hash.new

    rooms.each do |room|
      accommodations[room.accommodation.id] = room.accommodation
    end

    map_hash = Gmaps4rails.build_markers(accommodations.values) do |accommodation, marker|
      marker.lat accommodation.address.latitude
      marker.lng accommodation.address.longitude
    end

    return map_hash
  end

  def create_map_hash_from(rooms)
    return self.create_map_hash_from(rooms)
  end
end