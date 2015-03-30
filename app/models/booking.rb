class Booking < ActiveRecord::Base
  has_many :bookings_rooms
  has_many :rooms, through: :bookings_rooms
  has_many :bookings_guests
  has_many :guests, through: :bookings_guests
  belongs_to :guest
end
