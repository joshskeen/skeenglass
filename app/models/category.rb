class Category < ActiveRecord::Base
  has_and_belongs_to_many :products

  def as_json(options={})
  { :name => self.name,
    :products => self.products.where(:in_cart => false, :sold => false)
  }
  end

end
