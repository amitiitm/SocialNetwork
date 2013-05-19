class Item
  require "#{Dir.pwd}/sales_tax"
  attr_accessor :item_type
  attr_accessor :item_name
  attr_accessor :item_price
  
  def calculate_tax
    SalesTax.calculate_sales_tax(self)
  end

end