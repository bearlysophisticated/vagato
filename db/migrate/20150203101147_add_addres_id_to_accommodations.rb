class AddAddresIdToAccommodations < ActiveRecord::Migration
  def change
    add_column :accommodations, :address_id, :integer
  end
end
