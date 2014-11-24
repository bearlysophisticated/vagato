class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :country
      t.string :zip
      t.string :city
      t.string :address
      t.integer :accommodation_id

      t.timestamps
    end
  end
end
