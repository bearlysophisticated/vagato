class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :destroy, :update]
  before_action :set_bookings, only: [:index]
  before_action :authenticate_user!

  # GET /bookings
  def index
  end

  # GET /bookings/1
  def show
    if current_user.owner?
      @rooms = BookingsRoom.joins(room: [:accommodation]).where(:booking_id => @booking.id).where('accommodations.owner_id = ?', current_user.role.id)
      @inherited_booking_status = BookingsHelper.get_inherited_booking_status(@booking, current_user.role)
    elsif current_user.guest?
      @rooms = BookingsRoom.where(:booking_id => @booking.id)
      @comment = Comment.new
      @accommodations = Accommodation.joins(rooms: [:bookings_rooms]).where('bookings_rooms.booking_id = ?', @booking.id).uniq
    end

    @total_price = Hash.new
    @total_price['value'] = 0
    @total_price['currency'] = @rooms.first.room.price.currency

    @rooms.each do |r|
      @total_price['value'] += r.room.price.value_with_vat*@booking.num_of_nights
    end

    @guests = Hash.new
    if current_user.owner?
      tmp_guests = BookingsGuest.joins(room: [:accommodation]).where(:booking_id => @booking.id).where('accommodations.owner_id = ?', current_user.role.id)
    elsif current_user.guest?
      tmp_guests = BookingsGuest.where(:booking_id => @booking.id)
    end
    tmp_guests.each do |bg|
      @guests["#{@booking.id}#{bg.room_index}#{bg.bed}"] = bg.guest
    end
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      redirect_to @booking, notice: 'Booking was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bookings/1
  def update
    bookings_rooms = BookingsRoom.joins(room: [:accommodation]).where(:booking_id => @booking.id).where('accommodations.owner_id = ?', current_user.role.id)

    bookings_rooms.each do |br|
      br.status = params[:booking][:state]
      br.save!
    end

    BookingsHelper.check_and_set_booking_status(@booking)

    redirect_to "/bookings/#{params[:booking][:id]}"
  end

  # DELETE /bookings/1
  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: 'Booking was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def set_bookings
      @bookings = Hash.new
      @bookings['BOOKED'] = Array.new
      @bookings['ANSWERED'] = Array.new
      @bookings['CLOSED'] = Array.new

      if current_user.guest?
        Booking.where('guest_id' => current_user.role.id).where.not('state' => 'CART').each do |b|
          if b.state == 'APPROVED' || b.state == 'DENIED'
            @bookings['ANSWERED'].push(b)
          else
            @bookings[b.state].push(b)
          end
        end

      elsif current_user.owner?
        @rooms = Hash.new

        Booking.joins(rooms: [:accommodation]).where('accommodations.owner_id' => current_user.role.id).where.not('bookings.state' => 'CART').uniq.each do |b|
          inherited_booking_status = BookingsHelper.get_inherited_booking_status(b, current_user.role)

          if inherited_booking_status == 'APPROVED' || inherited_booking_status == 'DENIED'
            @bookings['ANSWERED'].push(b)
          else
            @bookings[inherited_booking_status].push(b)
          end

          b.rooms.each do |r|
            if r.accommodation.owner == current_user.role
              if @rooms[b.id].nil?
                @rooms[b.id] = Array.new
              end

              @rooms[b.id].push(r)
            end
          end
        end
      end
    end

    # Only allow a trusted parameter "white list" through.
    def booking_params
      params.require(:booking).permit(:start_date, :end_date, :num_of_nights, :state, :guest_id)
    end
end
