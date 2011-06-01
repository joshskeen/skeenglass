class Product < ActiveRecord::Base
    has_attached_file  :thumb
    has_many :product_images
end
