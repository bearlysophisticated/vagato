class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :filter
      t.string :base_url
      t.string :city
      t.date :start_date
      t.date :end_date
      t.integer :capacity
      t.integer :guests
      t.boolean :close
      t.boolean :cheap
      t.boolean :one_bed
      t.boolean :two_bed
      t.boolean :three_bed
      t.boolean :four_or_more_bed

      t.timestamps null: false
    end
  end
end
