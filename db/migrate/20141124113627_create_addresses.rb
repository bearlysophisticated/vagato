class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :country
      t.string :zip
      t.string :city
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :addressable_id
      t.string :addressable_type

      t.timestamps
    end
  end
end
