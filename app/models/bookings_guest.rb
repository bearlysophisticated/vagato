class BookingsGuest < ActiveRecord::Base
  belongs_to :guest
  belongs_to :booking
  belongs_to :room
end
