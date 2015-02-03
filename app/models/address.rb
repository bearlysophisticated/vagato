class Address < ActiveRecord::Base
  has_one :accommodation
  has_one :guest

  geocoded_by :full_address
  after_validation :geocode

  def full_address
  	"#{zip} #{country} #{city} #{address}"
  end
end
