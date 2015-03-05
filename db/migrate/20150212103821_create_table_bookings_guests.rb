class CreateTableBookingsGuests < ActiveRecord::Migration
  def change
    create_table :bookings_guests do |t|
      t.integer :guest_id
      t.integer :booking_id
      t.integer :room_id
      t.string :role

      t.timestamps
    end
  end
end
