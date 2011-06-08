class AddOrderIdToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :order_id, :integer
  end

  def self.down
    drop_column :products, :order_id, :integer
  end
end
