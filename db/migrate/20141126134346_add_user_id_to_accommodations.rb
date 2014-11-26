class AddUserIdToAccommodations < ActiveRecord::Migration
  def change
    add_column :accommodations, :user_id, :integer
  end
end
