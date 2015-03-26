module GeoHelper

  def self.calculate_distances_per_rooms(rooms)

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
        distance = destination.distance_to(start)
        sub_distances[subkey] = distance
      end

      distances[key] = sub_distances
    end

    return distances
  end

  def calculate_distances_per_bed(rooms)
    return self.calculate_distances_per_bed(rooms)
  end

end