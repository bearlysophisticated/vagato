class AddGuestIdToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :guest_id, :integer
  end
end
