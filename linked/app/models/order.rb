# == Schema Information
# Schema version: 20101221054709
#
# Table name: orders
#
#  id             :integer(4)      not null, primary key
#  product_id     :integer(4)
#  coupon_id      :integer(4)
#  reservation_id :integer(4)
#  user_name      :string(255)
#  shoe_type      :string(255)
#  board_stance   :string(255)
#  height         :string(255)
#  shoe_size      :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Order < ActiveRecord::Base

  belongs_to :product
  belongs_to :coupon, :counter_cache => true
  belongs_to :reservation

  validates_presence_of :user_name, :shoe_type, :height, :shoe_size
  validates_presence_of :board_stance

  def board_type?
    shoe_type == "board"
  end


  after_destroy :update_booking_number_of_reservation

  def update_booking_number_of_reservation
    orders_count = self.reservation.orders.size
    if orders_count == 0
      self.reservation.destroy
    else
      self.reservation.update_attribute(:booking_number, orders_count)
    end
  end


end
