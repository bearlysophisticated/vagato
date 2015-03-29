class CartController < ApplicationController
  before_action :authenticate_user!
  before_action :check_role

  def index
    @cart = CartHelper.get_cart_for(current_user.role)
    @rooms = @cart.rooms.sort_by { |r| r[:id]}
    @room_count = Hash.new
    @total_price = Hash.new
    @total_price['value'] = 0
    @total_price['currency'] = @rooms.size > 0 ? @rooms.first.price.currency : ''

    @rooms.each do |r|
      @total_price['value'] += r.price.value_with_vat*@cart.num_of_nights
    end

    i = 0
    while i < @rooms.size do
      if @room_count[@rooms[i].id].nil?
        @room_count[@rooms[i].id] = 1
      else
        @room_count[@rooms[i].id] += 1
      end

      if i+1 == @rooms.size
        break
      else
        if @rooms[i].id == @rooms[i+1].id
          @rooms.delete_at(i+1)
        else
          i += 1
        end
      end
    end

  end

  def add
    room = Room.find(params[:booking][:room_id])
    cart = Booking.find(params[:booking][:cart_id])

    start_date = nil
    end_date = nil

    if params[:booking][:start_date] && params[:booking][:end_date]
      start_date = params[:booking][:start_date].to_date
      end_date = params[:booking][:end_date].to_date
    elsif !cart.nil?
      start_date = cart.start_date
      end_date = cart.end_date
    end

    if room.nil? && cart.nil? && start_date.nil? && end_date.nil?
      flash[:alert] = 'Nem sikerült a szobafoglalást a kosárba rakni.'

    elsif CartHelper.is_addable(cart, room)
      # cart.rooms.push(room)
      booking_room = BookingsRoom.new
      booking_room.booking = cart
      booking_room.room = room
      booking_room.status = 'CART'
      booking_room.index = get_next_room_index(cart)

      if cart.start_date.nil?
        cart.start_date = start_date
      end

      if cart.end_date.nil?
        cart.end_date = end_date
      end

      cart.num_of_nights = end_date - start_date

      if cart.save! && booking_room.save!
        flash[:notice] = 'A szobafoglalást beraktam a kosárba!'
      else
        flash[:alert] = 'Nem sikerült a szobafoglalást a kosárba rakni.'
      end
    else
      flash[:alert] = 'Nem sikerült a szobafoglalást a kosárba rakni.'
    end

    redirect_to room_path(room.id)
  end


  def add_from_smartfilter
    rooms = params[:rooms].split(' ').map(&:to_i)
    puts rooms
    cart = CartHelper.get_cart_for(current_user.role)

    cart.rooms.clear
    cart.start_date = nil
    cart.end_date = nil

    if params[:start_date] && params[:end_date]
      start_date = params[:start_date].to_date
      end_date = params[:end_date].to_date
    end

    if cart.save! && !start_date.nil? && !end_date.nil?

      rooms.each do |r_id|
        room = Room.find(r_id)

        if room.nil? && cart.nil? && start_date.nil? && end_date.nil?
          flash[:alert] = 'Nem sikerült a szobafoglalástokat a kosárba rakni.'

        elsif CartHelper.is_addable(cart, room)
          # cart.rooms.push(room)
          booking_room = BookingsRoom.new
          booking_room.booking = cart
          booking_room.room = room
          booking_room.status = 'CART'
          booking_room.index = get_next_room_index(cart)

          if cart.start_date.nil?
            cart.start_date = start_date
          end

          if cart.end_date.nil?
            cart.end_date = end_date
          end

          if cart.num_of_nights.nil?
            cart.num_of_nights = end_date - start_date
          end

          if cart.save! && booking_room.save!
            flash[:notice] = 'A szobafoglalást beraktam a kosárba!'
          else
            flash[:alert] = 'Nem sikerült a szobafoglalást a kosárba rakni.'
          end
        else
          flash[:alert] = 'Nem sikerült a szobafoglalást a kosárba rakni.'
        end
      end
    end

    redirect_to '/cart'
  end


  def remove
    cart = Booking.find(params[:booking][:cart_id])
    room = Room.find(params[:booking][:room_id])

    unless cart.nil? && room.nil?
      rooms = cart.rooms.sort_by { |r| r[:id]}

      i = 0
      while i < rooms.size do
        if rooms[i].id == room.id
          rooms.delete_at(i)
          cart.rooms.clear

          if rooms.size > 0
            cart.rooms = rooms
          else
            cart.start_date = nil
            cart.end_date = nil
          end

          if cart.save!
            flash[:notice] = 'A szobafoglalást töröltem a kosárból.'
          end

          break
        end

        i += 1
      end
    end

    redirect_to '/cart'
  end

  def clear
    cart = Booking.find(params[:booking][:cart_id])

    if cart.nil?
      flash[:warn] = 'Nem sikerült kiüríteni a kosarat.'
    else
      cart.rooms.clear
      cart.start_date = nil
      cart.end_date = nil

      if cart.save!
        flash[:notice] = 'Kiürítettem a kosarat!'
      else
        flash[:alert] = 'Nem sikerült kiüríteni a kosarat.'
      end
    end

    redirect_to '/cart'
  end

  def book
    @booking = Booking.find(params[:booking][:booking_id])
    @rooms = BookingsRoom.where(:booking_id => @booking.id).sort_by{ |br| br.index}
    @total_price = Hash.new
    @total_price['value'] = 0
    @total_price['currency'] = @booking.rooms.first.price.currency

    @booking.rooms.each do |room|
      @total_price['value'] += room.price.value_with_vat*@booking.num_of_nights
    end
  end

  def finish_booking
    booking = Booking.find(params[:booking_id])
    rooms = BookingsRoom.where(:booking_id => booking.id)
    can_book = true

    if booking.nil?
      can_book = false
      flash[:warn] = 'Nem sikerült megtenni a foglalást.'
      puts 1
      redirect_to '/cart'
    else

      rooms.each do |r|
        if BookingsHelper.is_bookable(r.room, booking.start_date, booking.end_date) && can_book

          i = 0
          while i < r.room.capacity do
            guest_name = params["name#{r.index}#{i+1}"]
            guest_birth = params["birth#{r.index}#{i+1}"]

            unless guest_name.nil? && guest_birth.nil?
              if guest_name == current_user.role.name && guest_birth == current_user.role.day_of_birth.to_s.gsub!('-','.')
                bookings_guest = BookingsGuest.where('booking_id' => booking.id).where('guest_id' => current_user.role.id).first(1)
                bookings_guest[0].room = r.room
                bookings_guest[0].role = 'BOOKER'
                bookings_guest[0].bed = i+1
                bookings_guest[0].room_index = r.index
                bookings_guest[0].save!
              else
                guest = Guest.new
                guest.name = guest_name
                guest.day_of_birth = guest_birth
                guest.phone = 0
                guest.relative = current_user.role

                if guest.save!
                  bookings_guest = BookingsGuest.new
                  bookings_guest.guest = guest
                  bookings_guest.booking = booking
                  bookings_guest.room = r.room
                  bookings_guest.role = 'RELATIVE'
                  bookings_guest.bed = i+1
                  bookings_guest.room_index = r.index
                  bookings_guest.save!
                end
              end
            else
              can_book = false
              flash[:warn] = 'Hiányos mezők! Kérlek töltsd ki minden vendég adatát!'
              puts 2
              redirect_to '/cart'
            end

            i += 1
          end
        else
          can_book = false
          flash[:warn] = "Nem sikerült megtenni a foglalást. A #{r.room.name} szoba a(z) #{r.room.accommodation.name} szálláson nem elérhető a kiválasztott időszakban."
          puts 3
          redirect_to '/cart'
        end
      end

      if can_book
        booking.state = 'BOOKED'
        unless CartHelper.has_cart?(current_user.role)
          CartHelper.create_cart_for(current_user.role)
        end

        rooms_saved = true
        rooms.each do |r|
          r.status = 'BOOKED'
          rooms_saved &= r.save!
        end

        if booking.save! && rooms_saved
          flash[:notice] = "A foglalás véglegesítve lett! Foglalási szám: #{booking.id}"
          puts 4
          redirect_to bookings_path
        else
          flash[:warn] = 'Nem sikerült megtenni a foglalást.'
          puts 5
          redirect_to '/cart'
        end
      end
    end
  end

  private

  def check_role
    return current_user.guest?
  end

  def get_next_room_index(cart)
    next_index = 0
    BookingsRoom.where(:booking_id =>  cart.id).each do |br|
      next_index = br.index if next_index < br.index
    end

    return next_index+1
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :num_of_nights, :state, :guest_id)
  end
end
