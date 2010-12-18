# == Schema Information
# Schema version: 20101218012805
#
# Table name: products
#
#  id                       :integer(4)      not null, primary key
#  name                     :string(255)
#  provider_name            :string(255)
#  ticket_type              :string(255)
#  resort                   :string(255)
#  opened_at                :datetime
#  closed_at                :datetime
#  daily_reservations_limit :integer(4)      default(0)
#  created_at               :datetime
#  updated_at               :datetime
#

class Product < ActiveRecord::Base

  validates_presence_of :name, :provider_name
  validates_presence_of :ticket_type
  validates_presence_of :opened_at, :closed_at
  validates_presence_of :daily_reservations_limit
  validates_presence_of :resort, :unless => :free_type_ticket?

  validates_numericality_of :daily_reservations_limit



  has_many :coupons
  accepts_nested_attributes_for :coupons

  has_many :reservations

  has_many :product_constraints
  accepts_nested_attributes_for :product_constraints

  has_many :orders

  def free_type_ticket?
    self.ticket_type == "free"
  end

  def daily_reserved_orders_count(_date)
    count = 0
    reservations = self.reservations.where("used_at = ?", _date.to_time_in_current_zone).includes(:orders)
    reservations.each do |r|
      count += r.orders.count
    end
    count
  end

end
