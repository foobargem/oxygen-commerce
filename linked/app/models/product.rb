# == Schema Information
# Schema version: 20101218012805
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


  has_many :coupons
  accepts_nested_attributes_for :coupons

  has_many :reservations

  has_many :orders

  has_many :product_constraints



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



  serialize :constraints

  ["max_booking_counts"].each do |m|
    method_name = "constraints_#{m}"
    method_declaration = <<-EOF
      def #{method_name}
        self.constraints ||= {}
        self.constraints[:#{m}]
      end
      def #{method_name}=(value)
        self.constraints ||= {}
        self.constraints[:#{m}] = value
      end
    EOF
    eval method_declaration
  end


  def max_booking_count_per_oneday(resort = nil)
    if self.constraints
      unless resort.nil?
        self.constraints[:max_booking_counts][:"#{resort}"]
      else
        self.constraints[:max_booking_counts][:"#{self.resort}"]
      end
    end
  end

end
