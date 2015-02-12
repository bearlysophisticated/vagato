module CartHelper

  def create_cart_for(guest)
    return create_cart_for(guest)
  end

  def self.create_cart_for(guest)
    cart = Booking.new
    cart.state = 'CART'
    guest.bookings.push(cart)
  end

  def self.has_cart?(guest)
    guest.bookings.each do |b|
      return true if b.state == 'CART'
    end

    false
  end

  def has_cart?(guest)
    return self.has_cart?(guest)
  end

end