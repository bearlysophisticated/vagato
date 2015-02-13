class CartController < ApplicationController
  def index
    @cart = CartHelper.get_cart_for(current_user.role)
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
        cart.start_date = params[:booking][:start_date]
      end

      if cart.end_date.nil?
        cart.end_date = params[:booking][:end_date]
      end

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
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :num_of_nights, :state, :guest_id)
  end
end
