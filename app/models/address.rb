class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  geocoded_by :full_address
  after_validation :geocode

  validates :country, :zip, :city, :address, presence: true
  validates :zip, numericality: { only_integer: true }
  #validates :country, inclusion:{in:Country.all.map(&:pop)}

  def full_address
  	"#{zip} #{country} #{city} #{address}"
  end
end
