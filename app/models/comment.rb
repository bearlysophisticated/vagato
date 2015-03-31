class Comment < ActiveRecord::Base
  belongs_to :guest
  belongs_to :accommodation
  belongs_to :booking
end
