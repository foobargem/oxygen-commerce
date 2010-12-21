# == Schema Information
# Schema version: 20101221054709
#
# Table name: admins
#
#  id                   :integer(4)      not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(4)      default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  login                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class Admin < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  # :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation

end
