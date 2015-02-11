class Guest < ActiveRecord::Base
  has_one :address, :as => :addressable, dependent: :destroy
  has_one :user, :as => :role, dependent: :destroy
  has_and_belongs_to_many :bookings
  has_many :guests, :as => :relatives
  belongs_to :relative, :foreign_key => 'id', :class_name => 'Guest'

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :address

  validates :name, :phone, :day_of_birth, presence: true
  validates_associated :user
  validates_associated :address
end
