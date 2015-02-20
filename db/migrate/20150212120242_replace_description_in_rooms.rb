class ReplaceDescriptionInRooms < ActiveRecord::Migration
  def change
    remove_column :rooms, :description
    add_column :rooms, :description, :text
  end
end
