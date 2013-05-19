class Main
  require "#{Dir.pwd}/item"
  def main
    item_name_arr = []
    total_item_price = 0.0
    total_sales_tax = 0.0
    begin
      puts '
          Enter the type of Item...1,2,3,4
          1 for ITEM_WITH_NOSALESTAX_AND_NOIMPORTDUTY
          2 for ITEM_WITH_NOSALESTAX_ONLY_IMPORTDUTY
          3 for ITEM_WITH_ONLY_SALESTAX_AND_NOIMPORTDUTY
          4 for ITEM_WITH_BOTH_SALESTAX_AND_IMPORTDUTY
      '
      item_type = gets.chomp
      puts 'Enter Item Name'
      item_name = gets.chomp
      puts 'Enter Item price'
      item_price = gets.chomp
      item = Item.new
      item.item_type = item_type
      item.item_name = item_name
      item.item_price = item_price
      new_item_price = item.calculate_tax
      sales_tax = new_item_price - item_price.to_f
      item_name_arr << "#{item_name} : #{new_item_price.round(2)}"
      total_item_price = total_item_price + new_item_price
      total_sales_tax = total_sales_tax + sales_tax
     
    rescue Exception => ex
      puts ex
    ensure
      puts 'Do U want to continue...'
      answer = gets.chomp
    end while(answer.to_s.upcase == 'Y')
    puts "****** OUTPUT *******"
    puts item_name_arr
    puts "Sales Taxes : #{total_sales_tax.round(2)}"
    puts "Total : #{total_item_price.round(2)}"
  end
end
object = Main.new
object.main


