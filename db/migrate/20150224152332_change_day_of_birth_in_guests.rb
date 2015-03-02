class ChangeDayOfBirthInGuests < ActiveRecord::Migration
  def change
    change_column :guests, :day_of_birth, :date
  end
end
