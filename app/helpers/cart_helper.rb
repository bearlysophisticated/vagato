module CartHelper

  def create_cart_for(guest)
    return create_cart_for(guest)
  end

  def self.create_cart_for(guest)
    cart = Booking.new
    cart.state = 'CART'
    cart.guest_id = guest.id
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

  def self.get_cart_for(guest)
    unless self.has_cart?(guest)
      self.create_cart_for(guest)
    end

    guest.bookings.each do |b|
      return b if b.state == 'CART'
    end

    nil
  end

  def get_cart_for(guest)
    return self.get_cart_for(guest)
  end

  def self.is_addable(cart, room)
    num_of_same_rooms = 0
    cart.rooms.each do |r|
      if r.id == room.id
        num_of_same_rooms += 1
      end
    end

    return num_of_same_rooms < room.num_of_this
  end

  def is_addable(cart, room)
    return self.is_addable(cart, room)
  end

  def self.get_cart_size_for(guest)
    cart = self.get_cart_for(guest)

    unless cart.nil?
      return cart.rooms.size
    end

    return 0
  end

  def get_cart_size_for(guest)
    return self.get_cart_size_for(guest)
  end
end