class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.decimal :class
      t.string :code
      t.integer :accommodation_id

      t.timestamps
    end
  end
end
