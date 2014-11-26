class CreateAccommodationsServiices < ActiveRecord::Migration
  def change
    create_table :accommodations_serviices, id: false do |t|
    	t.belongs_to :accommodation
    	t.belongs_to :serviice
    end
  end
end
