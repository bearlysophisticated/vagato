class CreateBookingsRooms < ActiveRecord::Migration
  def change
    create_table :bookings_rooms do |t|
      t.integer :booking_id
      t.integer :room_id

      t.timestamps
    end
  end
end
