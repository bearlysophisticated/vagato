class Search < ActiveRecord::Base
  has_no_table

  column :start_date, :date
  column :end_date, :date
  column :smart, :boolean
end