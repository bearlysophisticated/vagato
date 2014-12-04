class Room < ActiveRecord::Base
  has_one :price
  belongs_to :accommodation

  has_and_belongs_to_many :equipments

  accepts_nested_attributes_for :price
  accepts_nested_attributes_for :equipments

  has_attached_file :image, 
  		:styles => { :medium => "200x200", :thumb => "100x100>" }, 
  		:default_url => "missing.gif",
      :storage => :dropbox,
  		:dropbox_credentials => Rails.root.join("config/dropbox.yml")
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
