class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :name
      t.string :phone
      t.datetime :day_of_birth
      t.integer :address_id

      t.timestamps null: false
    end
  end
end
