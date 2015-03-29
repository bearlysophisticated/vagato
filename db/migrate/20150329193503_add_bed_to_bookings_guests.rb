class AddBedToBookingsGuests < ActiveRecord::Migration
  def change
    add_column :bookings_guests, :bed, :integer
  end
end
