class ChangeDescriptionInAccommodations < ActiveRecord::Migration
  def change
    change_column :accommodations, :description, :text
  end
end
