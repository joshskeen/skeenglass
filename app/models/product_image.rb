class ProductImage < ActiveRecord::Base
  belongs_to :product
  has_attached_file  :image,  :styles => { :original => "600x600>"}
end
