class Guest < ActiveRecord::Base
  has_one :address, :as => :addressable, dependent: :destroy

  has_one :user, :as => :role, dependent: :destroy
  accepts_nested_attributes_for :user

  accepts_nested_attributes_for :address

  validates :name, :phone, :day_of_birth, presence: true
  validates_associated :user
  validates_associated :address
end
