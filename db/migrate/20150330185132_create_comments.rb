class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :stars
      t.text :text
      t.integer :guest_id
      t.integer :accommodation_id
      t.integer :booking_id

      t.timestamps null: false
    end
  end
end
