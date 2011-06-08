class Order < ActiveRecord::Base
  has_many :products
  
end
