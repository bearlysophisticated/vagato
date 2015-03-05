class CreateCategries < ActiveRecord::Migration
  def change
    create_table :categries do |t|
      t.string :name
      t.string :code
      t.integer :value

      t.timestamps
    end
  end
end
