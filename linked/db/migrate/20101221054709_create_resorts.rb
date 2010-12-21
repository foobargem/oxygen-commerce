class CreateResorts < ActiveRecord::Migration
  def self.up
    create_table :resorts do |t|
      t.string :name
      t.string :display_name

      t.integer :oneday_booking_limit_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :resorts
  end
end
