class Filter < ActiveRecord::Base
  has_many :equipments
  has_many :serviices
end
