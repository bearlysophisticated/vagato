class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :key
      t.text :value
      t.string :group

      t.timestamps null: false
    end
  end
end
