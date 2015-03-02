class AddRoleToBookingsGuests < ActiveRecord::Migration
  def change
    add_column :bookings_guests, :role, :string
  end
end
