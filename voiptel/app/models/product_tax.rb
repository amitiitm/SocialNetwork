class ProductTax < ActiveRecord::Base
  has_many :tax_items
  
  validates_presence_of :product_name, :message => "Product name can't be balnk!"
  validates_presence_of :product_code, :message => "Product code can't be blank"
  
  accepts_nested_attributes_for :tax_items, :allow_destroy => true
  
  def tax_items_to_a
    if self.tax_items.size > 0
      self.tax_items.all.map {|i| i.percentage / 100}
    end
  end
  
  def total_tax
    self.tax_items.sum(:percentage) / 100
  end
  
end
