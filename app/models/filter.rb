class Filter < ActiveRecord::Base
  has_no_table

  column :start_date, :date
  column :end_date, :date
  column :smart, :boolean
  column :capacity, :int

  has_many :equipments
  has_many :serviices
end