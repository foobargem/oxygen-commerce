class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.integer :coupon_id

      t.string :height
      t.string :shoe_size

      t.string :resort

      t.datetime :used_at
      t.string :part_time
      
      t.timestamps
    end
  end

  def self.down
    drop_table :reservations
  end
end
