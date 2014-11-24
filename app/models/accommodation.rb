class Accommodation < ActiveRecord::Base
  has_one :category
  has_one :address
  has_many :equipments, through: :accommodationEquipments
  has_many :rooms

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :category
  accepts_nested_attributes_for :equipments
end
