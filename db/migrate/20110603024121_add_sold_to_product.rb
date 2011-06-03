class AddSoldToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :sold, :boolean, :default => false
  end

  def self.down
    remove_column :products, :sold
  end
end
