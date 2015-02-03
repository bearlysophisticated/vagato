class Owner < ActiveRecord::Base
  has_many :accommodations #, dependent: :destroy

  has_one :user, :as => :role, dependent: :destroy
  accepts_nested_attributes_for :user

  validates :name, presence: true
  validates :name, absence: true
  validates_associated :user
end
