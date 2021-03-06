# == Schema Information
# Schema version: 20101221054709
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
  validates_uniqueness_of :unavailabled_at, :scope => :product_id



end
