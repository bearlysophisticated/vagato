class ReplaceDescriptionInAcommodation < ActiveRecord::Migration
  def change
    remove_column :accommodations, :description
    add_column :accommodations, :description, :text
  end
end
