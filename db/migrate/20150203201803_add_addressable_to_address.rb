class AddAddressableToAddress < ActiveRecord::Migration
  def change
    remove_column :guests, :address_id
    remove_column :accommodations, :address_id
    add_column :addresses, :addressable_id, :integer
    add_column :addresses, :addressable_type, :string
  end
end
