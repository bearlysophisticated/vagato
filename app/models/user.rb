class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :role, polymorphic: true

  def guest?
    self.role.is_a? Guest
  end

  def owner?
    self.role.is_a? Owner
  end

  def admin?
    self.role.is_a? Admin
  end

  def role?
    self.role_type
  end
end
