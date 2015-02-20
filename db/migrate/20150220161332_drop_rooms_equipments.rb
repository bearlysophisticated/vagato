class DropRoomsEquipments < ActiveRecord::Migration
  def change
    drop_table :rooms_equipments
  end
end
