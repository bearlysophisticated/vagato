class RemoveUserIdFromAccommodations < ActiveRecord::Migration
  def change
    remove_column :accommodations, :user_id
  end
end
