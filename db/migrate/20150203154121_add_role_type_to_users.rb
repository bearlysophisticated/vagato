class AddRoleTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role_type, :string
    remove_column :users, :role
  end
end
