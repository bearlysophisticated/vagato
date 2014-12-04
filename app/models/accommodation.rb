class Accommodation < ActiveRecord::Base
  belongs_to :user
  has_one :address
  has_one :categry
#  has_many :accommodation_equipments
#  has_many :equipments, through: :accommodation_equipments
  has_and_belongs_to_many :serviices
  has_many :rooms

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :categry
  accepts_nested_attributes_for :serviices

  has_attached_file :image, 
      :styles => { :medium => "200x200", :thumb => "100x100>" }, 
      :default_url => "missing.gif",
      :storage => :dropbox,
      :dropbox_credentials => Rails.root.join("config/dropbox.yml")
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
