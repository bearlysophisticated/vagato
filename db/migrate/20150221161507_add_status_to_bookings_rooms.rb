class AddStatusToBookingsRooms < ActiveRecord::Migration
  def change
    add_column :bookings_rooms, :status, :string
  end
end
