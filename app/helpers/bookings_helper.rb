module BookingsHelper
  def self.is_bookable(room, start_date, end_date)
    if start_date.nil? && end_date.nil?
      return true
    end

    bookings = Booking.joins(:rooms).where.not('state' => 'CART').where('rooms.id' => room.id)

    overlapping = 0
    bookings.each do |b|
      if overlaps(start_date, end_date, b)
        overlapping += 1
      end
    end

    return true if overlapping < room.num_of_this

    return false
  end

  def is_bookable(room, start_date, end_date)
    return self.is_bookable(room, start_date, end_date)
  end


  def self.get_free_rooms_count(room, start_date, end_date)
    if start_date.nil? && end_date.nil?
      return 0
    end

    bookings = Booking.joins(:rooms).where.not('state' => 'CART').where('rooms.id' => room.id)

    overlapping = 0
    bookings.each do |b|
      if overlaps(Date.strptime(start_date, '%Y.%m.%d'), Date.strptime(start_date, '%Y.%m.%d'), b)
        overlapping += 1
      end
    end

    return (room.num_of_this - overlapping)
  end

  def get_free_rooms_count(room, start_date, end_date)
    return self.get_free_rooms_count(room, start_date, end_date)
  end


  # Check if a given interval overlaps this interval
  def self.overlaps(start_date, end_date, base)
    (start_date - base.end_date) * (base.start_date - end_date) >= 0
  end
end
