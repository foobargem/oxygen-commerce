class ProductConstraint < ActiveRecord::Base

  belongs_to :product

  validates_presence_of :unavailabled_at
  validates_uniqueness_of :unavailabled_at, :scope => :product_id



end
