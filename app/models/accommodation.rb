class Accommodation < ActiveRecord::Base
  has_one :category
  has_one :address
  has_many :equipments, through: :accommodationEquipments
  has_many :rooms

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :category
  accepts_nested_attributes_for :equipments

  has_attached_file :image, :styles => { :medium => "200x", :thumb => "100x100>" }, :default_url => "missing.gif"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
