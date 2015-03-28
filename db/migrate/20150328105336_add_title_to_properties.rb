class AddTitleToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :title, :string
  end
end
