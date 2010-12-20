class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name

      t.string :ticket_type

      t.string :resort
      t.string :provider_name

      t.datetime :opened_at
      t.datetime :closed_at

      #t.integer :daily_reservations_limit, :default => 0

      # serialized
      t.text :constraints

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
