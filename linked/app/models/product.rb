# == Schema Information
# Schema version: 20101221054709
#
# Table name: products
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  ticket_type   :string(255)
#  resort        :string(255)
#  provider_name :string(255)
#  opened_at     :datetime
#  closed_at     :datetime
#  constraints   :text
#  created_at    :datetime
#  updated_at    :datetime
#

class Product < ActiveRecord::Base

  attr_accessor :booking_limit_count

  validates_presence_of :name, :provider_name
  validates_presence_of :ticket_type
  validates_presence_of :opened_at, :closed_at
  validates_presence_of :resort, :unless => :free_type_ticket?


  has_many :coupons, :dependent => :destroy
  accepts_nested_attributes_for :coupons

  has_many :reservations, :dependent => :nullify

  has_many :orders, :dependent => :nullify

  has_many :product_constraints, :dependent => :destroy



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
