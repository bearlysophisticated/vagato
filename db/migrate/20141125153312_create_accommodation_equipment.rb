class CreateAccommodationEquipment < ActiveRecord::Migration
  def change
    create_table :accommodations_equipment, id: false do |t|
    	t.belongs_to :accommodation
    	t.belongs_to :equipment
    end
  end
end
