class Product < ActiveRecord::Base
    has_attached_file  :thumb, :styles => {:small => "50x50>"}
    has_many :product_images
    has_and_belongs_to_many :categories
end
