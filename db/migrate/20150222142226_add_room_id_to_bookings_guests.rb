class AddRoomIdToBookingsGuests < ActiveRecord::Migration
  def change
    add_column :bookings_guests, :room_id, :integer
  end
end
