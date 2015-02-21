module BookingsHelper
  def self.is_bookable(room, start_date, end_date)
    unless start_date.nil? && end_date.nil?
      bookings = Booking.joins(:rooms).where.not('state' => 'CART').where('rooms.id' => room.id)

      overlapping = 0
      bookings.each do |b|
        if overlaps(start_date, end_date, b)
          overlapping += 1
        end
      end

      return true if overlapping < room.num_of_this
    end

    return false
  end

  def is_bookable(room, start_date, end_date)
    return self.is_bookable(room, start_date, end_date)
  end

  # Check if a given interval overlaps this interval
  def self.overlaps(start_date, end_date, base)
    (start_date - base.end_date) * (base.start_date - end_date) >= 0
  end
end
