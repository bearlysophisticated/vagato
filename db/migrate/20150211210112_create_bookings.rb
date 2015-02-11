class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.date :start_date
      t.date :end_date
      t.integer :num_of_nights
      t.string :state
      t.integer :guest_id

      t.timestamps null: false
    end
  end
end
