class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.integer :coupon_id
      t.integer :product_id

      # 예약자
      t.string :subscriber_name

      # 예약인원
      t.integer :booking_number

      t.datetime :used_at
      t.string :part_time
      t.string :resort


      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
