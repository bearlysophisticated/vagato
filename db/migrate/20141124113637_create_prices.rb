class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.float :value
      t.string :currency
      t.float :ifa
      t.float :vat
      t.integer :room_id

      t.timestamps
    end
  end
end
