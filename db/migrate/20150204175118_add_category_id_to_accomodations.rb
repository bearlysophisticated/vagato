class AddCategoryIdToAccomodations < ActiveRecord::Migration
  def change
    add_column :accommodations, :categry_id, :integer
  end
end
