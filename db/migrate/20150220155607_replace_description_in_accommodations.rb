class ReplaceDescriptionInAccommodations < ActiveRecord::Migration
  def change
    remove_column :accommodations, :description, :text
    add_column :accommodations, :description, :text
  end
end
