class Booking < ActiveRecord::Base
  #has_and_belongs_to_many :rooms
  has_many :bookings_rooms
  has_many :rooms, through: :bookings_rooms
  has_many :guests, through: :bookings_guests
  belongs_to :guest
end
