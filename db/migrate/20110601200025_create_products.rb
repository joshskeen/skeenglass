class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.boolean :in_cart
      t.integer :price
      t.string :thumb_file_name
      t.string :thumb_content_type
      t.integer :thumb_file_size
      t.datetime :thumb_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
