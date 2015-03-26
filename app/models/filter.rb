class Filter < ActiveRecord::Base
  has_no_table

  column :start_date, :date
  column :end_date, :date
  column :filter, :string
  column :capacity, :int
  column :city, :string
  column :guests, :int
=begin
  column :close, :int
  column :cheap, :int
=end

  has_many :equipments
  has_many :serviices
end