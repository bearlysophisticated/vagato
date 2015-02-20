class CreateEquipmentRooms < ActiveRecord::Migration
  def change
    create_table :equipment_rooms do |t|
      t.integer :equipment_id
      t.integer :room_id

      t.timestamps
    end
  end
end
