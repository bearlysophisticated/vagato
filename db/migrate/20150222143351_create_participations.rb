class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :guest_id
      t.integer :booking_id
      t.integer :room_id

      t.timestamps null: false
    end
  end
end
