class Room < ActiveRecord::Base
  has_many :equipment, through: :roomEquipments
  has_one :price
  belongs_to :accommodation

  has_attached_file :image, :styles => { :medium => "200x", :thumb => "100x100>" }, :default_url => "missing.gif"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
