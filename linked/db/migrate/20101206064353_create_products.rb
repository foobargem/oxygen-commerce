class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.string :provider_name

      # 이용권 종류(시즌권,개별권)
      t.string :ticket_type

      # 스키장
      t.string :resort

      t.datetime :opened_at
      t.datetime :closed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
