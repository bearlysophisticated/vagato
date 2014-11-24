class Address < ActiveRecord::Base
  has_one :coordinate
  belongs_to :accommodation
end
