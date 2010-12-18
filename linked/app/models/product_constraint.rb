# == Schema Information
# Schema version: 20101218012805
#
# Table name: product_constraints
#
#  id              :integer(4)      not null, primary key
#  product_id      :integer(4)
#  unavailabled_at :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class ProductConstraint < ActiveRecord::Base

  belongs_to :product

  validates_presence_of :unavailabled_at

end
