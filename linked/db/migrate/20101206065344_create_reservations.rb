class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.integer :coupon_id
      t.integer :product_id

      t.string :user_name
      t.string :resort

      # 장비
      t.string :shoe_type
      t.string :board_stance
      t.string :height
      t.string :shoe_size

      t.datetime :used_at
      t.string :part_time
      
      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
