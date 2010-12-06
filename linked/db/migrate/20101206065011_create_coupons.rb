class CreateCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons do |t|
      t.integer :product_id

      t.string :coupon_number

      # 구매자
      t.string :purchaser_name

      # 구매업체(중계업체)
      t.string :agency_name

      t.string :phone_number

      t.timestamps
    end
  end

  def self.down
    drop_table :coupons
  end
end
