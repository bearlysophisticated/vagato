class CreateServiices < ActiveRecord::Migration
  def change
    create_table :serviices do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
