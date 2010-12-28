class AddIndex < ActiveRecord::Migration
  def self.up
    add_index :coupons, :coupon_number
    add_index :reservations, :subscriber_name
  end

  def self.down
    remove_index :coupons, :coupon_number
    remove_index :reservations, :subscriber_name
  end
end
