class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /bookings
  def index
    if current_user.guest?
      @bookings = Hash.new
      @bookings['BOOKED'] = Array.new
      @bookings['APPROVED'] = Array.new
      @bookings['CLOSED'] = Array.new

      Booking.where('guest_id' => current_user.role.id).where.not('state' => 'CART').each do |b|
        @bookings[b.state].push(b)
      end

=begin
      @booked_bookings = Booking.where('guest_id' => current_user.role.id).where('state' => 'BOOKED')
      @approved_bookings = Booking.where('guest_id' => current_user.role.id).where('state' => 'APPROVED')
      @closed_bookings = Booking.where('guest_id' => current_user.role.id).where('state' => 'CLOSED')
=end
    elsif current_user.owner?
      @bookings = Booking.all
    end
  end

  # GET /bookings/1
  def show
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
    if @booking.update(booking_params)
      redirect_to @booking, notice: 'Booking was successfully updated.'
    else
      render :edit
    end
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

    # Only allow a trusted parameter "white list" through.
    def booking_params
      params.require(:booking).permit(:start_date, :end_date, :num_of_nights, :state, :guest_id)
    end
end
