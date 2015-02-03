class Guest < ActiveRecord::Base
  belongs_to :address, dependent: :destroy

  has_one :user, :as => :role, dependent: :destroy
  accepts_nested_attributes_for :user

  accepts_nested_attributes_for :address
end
