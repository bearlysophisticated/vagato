class CreateCategries < ActiveRecord::Migration
  def change
    create_table :categries do |t|
      t.string :name
      t.string :code
      t.integer :value
      t.integer :accommodation_id

      t.timestamps
    end
  end
end
