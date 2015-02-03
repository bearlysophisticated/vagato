class AddOwnerIdToAccommodations < ActiveRecord::Migration
  def change
    add_column :accommodations, :owner_id, :integer
  end
end
