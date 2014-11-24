class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :code
      t.integer :accommodation_id
      t.integer :num_of_this
      t.integer :capacity
      t.string :description

      t.timestamps
    end
  end
end
