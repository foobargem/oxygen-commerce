class Admin < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  # :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation

end
