class CreateRoomEquipments < ActiveRecord::Migration
  def change
    create_table :room_equipments do |t|
      t.integer :room_id
      t.integer :equipment_id

      t.timestamps
    end
  end
end
