class AddAttachmentToAccommodation < ActiveRecord::Migration
  def self.up
    change_table :accommodations do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :accommodations, :image
  end
end
