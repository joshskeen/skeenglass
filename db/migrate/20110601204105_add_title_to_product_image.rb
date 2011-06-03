class AddTitleToProductImage < ActiveRecord::Migration
  def self.up
    change_table :product_images do |t|
      remove_column(:product_images, :string)
      add_column(:product_images, :title, :string)
      
    end
  end

  def self.down
    remove_column :title
  end
end
