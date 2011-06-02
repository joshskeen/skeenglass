class ProductImage < ActiveRecord::Base
  belongs_to :product
  has_attached_file  :image,  :styles => { :original => "600x600>", :small => "100x100>"}
  def as_json(options={})
  {
    :title => self.title,
    :image_path => self.image.url
  }
  end
end
