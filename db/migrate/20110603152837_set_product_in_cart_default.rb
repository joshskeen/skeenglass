class SetProductInCartDefault < ActiveRecord::Migration
  def self.up
    change_column_default(:products, :in_cart, false)
  end

  def self.down
  end
end
