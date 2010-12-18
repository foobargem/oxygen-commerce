class CreateProductConstraints < ActiveRecord::Migration
  def self.up
    create_table :product_constraints do |t|
      t.integer :product_id

      t.datetime :unavailabled_at

      t.timestamps
    end
  end

  def self.down
    drop_table :product_constraints
  end
end
