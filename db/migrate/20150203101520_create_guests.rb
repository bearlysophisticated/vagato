class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :name
      t.string :phone
      t.date :day_of_birth
      t.integer :guest_id

      t.timestamps null: false
    end
  end
end
