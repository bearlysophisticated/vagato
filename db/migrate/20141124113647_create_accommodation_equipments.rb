class CreateAccommodationEquipments < ActiveRecord::Migration
  def change
    create_table :accommodation_equipments do |t|
      t.integer :accommodation_id
      t.integer :equipment_id

      t.timestamps
    end
  end
end
