class CreateProductsCategories < ActiveRecord::Migration
  def self.up
    create_table :categories_products, :id => false do |t|
      t.references :category, :null => false
      t.references :product, :null => false
    end
  end

  def self.down
    #drop_table :products_categories
    drop_table :categories_products
  end
end
