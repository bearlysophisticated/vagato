class Room < ActiveRecord::Base
  has_many :equipment, through: :roomEquipments
  has_one :price
  belongs_to :accommodation
end
