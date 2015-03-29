class AddIndexToBookingsRooms < ActiveRecord::Migration
  def change
    add_column :bookings_rooms, :index, :integer
  end
end
