module BookingsHelper
  def self.is_bookable(room, start_date, end_date)
    bookings = Booking.joins(:rooms).where('rooms.id' => room.id)

    puts '*** Bookings ***'
    puts bookings.size

    overlapings = 0
    bookings.each do |b|
      if overlaps(start_date, end_date, b)
        overlapings += 1
      end
    end

    puts '*** Overlapings ***'
    puts overlapings

    return true if overlapings < room.num_of_this
    return false
  end

  def is_bookable(room, start_date, end_date)
    return self.is_bookable(room, start_date, end_date)
  end

  # Check if a given interval overlaps this interval
  def self.overlaps(start_date, end_date, b2)
    (start_date - b2.end_date) * (b2.start_date - end_date) >= 0
  end
end
