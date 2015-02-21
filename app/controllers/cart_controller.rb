class CartController < ApplicationController
  def index
    @cart = CartHelper.get_cart_for(current_user.role)
    @rooms = @cart.rooms.sort_by { |r| r[:id]}
    @room_count = Hash.new

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

    puts @room_count.to_s
    puts @rooms.to_s
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
      cart.rooms.push(room)

      if cart.start_date.nil?
        cart.start_date = start_date
      end

      if cart.end_date.nil?
        cart.end_date = end_date
      end

      cart.num_of_nights = end_date - start_date

      if cart.save!
        flash[:notice] = 'A szobafoglalást beraktam a kosárba!'
      else
        flash[:alert] = 'Nem sikerült a szobafoglalást a kosárba rakni.'
      end
    else
      flash[:alert] = 'Nem sikerült a szobafoglalást a kosárba rakni.'
    end

    redirect_to room_path(room.id)
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
    booking = Booking.find(params[:booking][:booking_id])

    if booking.nil?
      flash[:warn] = 'Nem sikerült megtenni a foglalást.'
    else
      booking.state = 'BOOKED'
      CartHelper.create_cart_for(current_user.role)

      if booking.save!
        flash[:notice] = 'A foglalás rögzítve lett!'
      else
        flash[:warn] = 'Nem sikerült megtenni a foglalást.'
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :num_of_nights, :state, :guest_id)
  end
end
