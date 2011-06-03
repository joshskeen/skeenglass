class Product < ActiveRecord::Base
    has_attached_file  :thumb, :styles => {:small => "50x50>"}
    has_many :product_images
    has_and_belongs_to_many :categories
    cattr_reader :per_page
    @@per_page = 10

  def as_json(options={})
  { :name => self.name,
    :id => self.id,
    :thumb => self.thumb.url,
    :price => self.price,
    :product_images => self.product_images
  }
  end
end
