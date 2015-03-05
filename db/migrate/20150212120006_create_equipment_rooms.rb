class CreateEquipmentRooms < ActiveRecord::Migration
  def change
    create_table :equipment_rooms do |t|
      t.integer :room_id
      t.integer :equipment_id

      t.timestamps
    end
  end
end
