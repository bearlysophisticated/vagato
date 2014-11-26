class CreateRoomsEquipment < ActiveRecord::Migration
  def change
    create_table :rooms_equipments, id: false do |t|
    	t.belongs_to :room
    	t.belongs_to :equipment
    end
  end
end
