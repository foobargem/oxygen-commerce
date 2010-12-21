# == Schema Information
# Schema version: 20101221054709
#
# Table name: resorts
#
#  id                         :integer(4)      not null, primary key
#  name                       :string(255)
#  display_name               :string(255)
#  oneday_booking_limit_count :integer(4)      default(0)
#  created_at                 :datetime
#  updated_at                 :datetime
#

class Resort < ActiveRecord::Base

  validates_presence_of :oneday_booking_limit_count
  validates_numericality_of :oneday_booking_limit_count

end
