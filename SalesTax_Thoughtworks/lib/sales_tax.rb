class SalesTax
  def self.calculate_sales_tax(item)
    case item.item_type.to_i
    when 1
      return item.item_price.to_f
    when 2
      return item.item_price.to_f * 1.1
    when 3
      return item.item_price.to_f * 1.05
    when 4
      return item.item_price.to_f * 1.15
    else
      raise "Wrong choice"
    end
  end
end