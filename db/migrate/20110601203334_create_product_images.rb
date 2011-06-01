class CreateProductImages < ActiveRecord::Migration
  def self.up
    create_table :product_images do |t|
      t.integer :product_id
      t.integer :string
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :product_images
  end
end
