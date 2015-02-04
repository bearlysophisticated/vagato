class RemoveUnusedTables < ActiveRecord::Migration
  def change
    drop_table :accommodation_equipments
    drop_table :accommodations_equipment
    drop_table :coordinates
  end
end
