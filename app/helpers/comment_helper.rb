module CommentHelper

  def get_average_stars_for(criteria)
    if criteria.is_a? Accommodation
      return self.get_average_stars_for_accommodation(criteria)
    elsif criteria.is_a? Room
      return get_average_stars_for_room(criteria)
    end
  end


  def self.get_average_stars_for_accommodation(accommodation)
    avg_stars = 0
    accommodation.comments.each do |c|
      avg_stars += c.stars
    end

    return avg_stars/accommodation.comments.size
  end


  def self.get_average_stars_for_room(room)
    avg_stars = 0
    room.accommodation.comments.each do |c|
      avg_stars += c.stars
    end

    return avg_stars/room.accommodation.comments.size
  end

end
