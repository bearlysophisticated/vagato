class RemoveAccommodationIdFromCategry < ActiveRecord::Migration
  def change
    remove_column :categries, :accommodation_id
  end
end
