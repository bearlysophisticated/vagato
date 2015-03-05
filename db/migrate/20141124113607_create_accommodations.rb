class CreateAccommodations < ActiveRecord::Migration
  def change
    create_table :accommodations do |t|
      t.string :name
      t.string :code
      t.text :description
      t.integer :owner_id
      t.integer :categry_id

      t.timestamps
    end
  end
end
