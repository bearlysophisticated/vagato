class AccommodationEquipment < ActiveRecord::Base
  belongs_to :accommodation
  belongs_to :equipment
end
