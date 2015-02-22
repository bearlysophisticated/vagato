class Guest < ActiveRecord::Base
  # Personal address
  has_one :address, :as => :addressable, dependent: :destroy
  # Login credentials
  has_one :user, :as => :role, dependent: :destroy
  # As a user, have bookings and relatives who are not users
  has_many :bookings
  has_many :guests, :as => :relatives
  # As a fictional guest, have bookings where you participate and have relative who's a real user
  has_many :bookings, through: :bookings_guests, :as => :travels
  belongs_to :relative, :foreign_key => 'id', :class_name => 'Guest'

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :address

  validates :name, :phone, :day_of_birth, presence: true
  validates_associated :user
  validates_associated :address
end
