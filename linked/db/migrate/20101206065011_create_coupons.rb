class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.integer :product_id

      t.string :coupon_number

      # 구매수량/사용한 수량
      t.integer :quantity, :default => 0
      t.integer :reservations_count, :default => 0

      # 구매자
      t.string :purchaser_name
      t.string :phone_number

      # 구매업체(중계업체)
      t.string :agency_name

      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
