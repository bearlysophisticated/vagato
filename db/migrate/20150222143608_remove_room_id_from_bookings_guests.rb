class RemoveRoomIdFromBookingsGuests < ActiveRecord::Migration
  def change
    remove_column :bookings_guests, :room_id
  end
end
