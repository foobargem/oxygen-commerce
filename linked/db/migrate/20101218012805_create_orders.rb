class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :product_id
      t.integer :coupon_id
      t.integer :reservation_id


      # 장비
      t.string :user_name
      t.string :shoe_type
      t.string :board_stance
      t.string :height
      t.string :shoe_size


      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
