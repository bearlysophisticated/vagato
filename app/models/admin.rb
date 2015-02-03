class Admin < ActiveRecord::Base
  has_one :user, :as => :role, dependent: :destroy
  accepts_nested_attributes_for :user

  validates :name, :phone, presence: true
  validates_associated :user
end
