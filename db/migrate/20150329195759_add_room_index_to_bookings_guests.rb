class AddRoomIndexToBookingsGuests < ActiveRecord::Migration
  def change
    add_column :bookings_guests, :room_index, :integer
  end
end
