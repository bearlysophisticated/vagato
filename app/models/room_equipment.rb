class RoomEquipment < ActiveRecord::Base
  belongs_to :room
  belongs_to :equipment
end
