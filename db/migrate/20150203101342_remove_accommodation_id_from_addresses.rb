class RemoveAccommodationIdFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :accommodation_id
  end
end
