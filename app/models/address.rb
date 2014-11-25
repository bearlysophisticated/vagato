class Address < ActiveRecord::Base
  belongs_to :accommodation

  geocoded_by :full_address
  after_validation :geocode

  def full_address
  	"#{zip} #{country} #{city} #{address}"
  end
end
