# == Schema Information
# Schema version: 20101218012805
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
  validates_presence_of :board_stance, :if => :board_type?

  def board_type?
    shoe_type == "board"
  end

end
