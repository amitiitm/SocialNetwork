class Item::CatalogItemLib
include General

def self.import_item_packet_data(worksheet)
  worksheet.each_with_index {|row,row_index| 
    case row_index
      when 0
      else
        catalog_item_id=0; catalog_item_category_id=0; catalog_item_packet_id=0; category_attribute_id = 0; category_attribute_value_id = 0
        attribute1 = '';attribute2 ='';attribute3='';attribute4='';attribute5='';attribute6=''
        item_description = ''; image_name=''; meta_tag=''
        row.each_with_index{|cell,cell_index| 
         cell_value = cell.to_s('latin1').capitalize if cell ; 
            case cell_index
            when 0 #item category
              catalog_item_category = Item::CatalogItemCategory.find_or_create_by_code(:code => cell_value, :name => cell_value)
              catalog_item_category.save
              catalog_item_category_id = catalog_item_category.id
#              catalog_attribute = Item::CatalogAttribute.find_or_create_by_code(:code => cell_value, :name => cell_value)
#              catalog_attribute.save
#              category_attribute_id = catalog_attribute.id
#              catalog_attribute_value = Item::CatalogAttributeValue.find_or_create_by_code_and_catalog_attribute_id(:catalog_attribute_id=>category_attribute_id, :code => 'Yes', :name => 'Yes')
#              catalog_attribute_value.save
#              category_attribute_value_id = catalog_attribute_value.id
#              catalog_attribute_value = Item::CatalogAttributeValue.find_or_create_by_code_and_catalog_attribute_id(:catalog_attribute_id=>category_attribute_id, :code => 'No', :name => 'No')
#              catalog_attribute_value.save
              meta_tag += cell_value + ' '
            when 1 #item code
              catalog_item = Item::CatalogItem.find_or_create_by_web_code(:catalog_item_category_id=>catalog_item_category_id,:web_code => cell_value, :store_code=>cell_value, :name => cell_value)
              catalog_item.save
              catalog_item_id = catalog_item.id
              meta_tag += cell_value + ' '
            when 2 #item description
              item_description = cell_value
              meta_tag += cell_value + ' '
            when 3 #item price
              catalog_item_price = Item::CatalogItemPrice.find_or_create_by_catalog_item_id(:catalog_item_id=>catalog_item_id, :price=>cell_value, :from_date=>Time.now, :to_date=>( Time.now+ 365.days))
              catalog_item_price.save
            when 4 #image_name
              image_name = cell_value 
              catalog_item = Item::CatalogItem.find_by_id(catalog_item_id)
              catalog_item.purchase_description = item_description
              catalog_item.sale_description = item_description
              catalog_item.image_small = image_name
              catalog_item.image_normal = image_name
              catalog_item.image_enlarge = image_name
              catalog_item.image_thumnail = image_name
              catalog_item.meta_tag = meta_tag
              catalog_item.save
            when 5
              catalog_item_packet = Item::CatalogItemPacket.find_or_create_by_code(:catalog_item_id=>catalog_item_id,:code => cell_value, :name => cell_value)
              catalog_item_packet.save
              catalog_item_packet_id = catalog_item_packet.id
            when 6
              attribute1 = cell_value
            when 7
              attribute2 = cell_value
            when 8
              attribute3 = cell_value
            when 9
              attribute4 = cell_value
            when 10
              attribute5 = cell_value
            when 11
              attribute6 = cell_value
              catalog_item_packet = Item::CatalogItemPacket.find_or_create_by_id(:id => catalog_item_packet_id, 
                                      :attribute1 => attribute1,
                                      :attribute2 => attribute2,
                                      :attribute3 => attribute3,
                                      :attribute4 => attribute4,
                                      :attribute5 => attribute5,
                                      :attribute6 => attribute6)
              catalog_item_packet.save
            else
            end
          }
      end
  } 
end
  
def self.import_item_packet_inventory(worksheet)
  inventory_transaction = Inventory::InventoryTransaction.new()
  inventory_transaction.fill_default_header_values() if inventory_transaction.new_record?
  inventory_transaction.max_serial_no = inventory_transaction.inventory_transaction_lines.maximum_serial_no
  worksheet.each_with_index {|row,row_index| 
    case row_index
      when 0
      else
        catalog_item_id=0; catalog_item_packet_id=0; catalog_item_code='';catalog_item_packet_code=''; catalog_item_price=0
        row.each_with_index{|cell,cell_index| 
         cell_value = cell.to_s('latin1').capitalize if cell ; 
            case cell_index
            when 1 #item code
              catalog_item = Item::CatalogItem.find_by_store_code(cell_value)
              catalog_item_id = catalog_item.id
              catalog_item_code = cell_value
            when 3 #item price
              catalog_item_price = cell_value
            when 5
              catalog_item_packet = Item::CatalogItemPacket.find_by_code(cell_value)
              catalog_item_packet_id = catalog_item_packet.id
              catalog_item_packet_code = cell_value
              inventory_transaction_line = inventory_transaction.inventorytransactionlines('inventory_transaction_line','')
              inventory_transaction_line.catalog_item_id = catalog_item_id
              inventory_transaction_line.catalog_item_code = catalog_item_code
              inventory_transaction_line.catalog_item_packet_id = catalog_item_packet_id
              inventory_transaction_line.catalog_item_packet_code = catalog_item_packet_code
              inventory_transaction_line.receipt_issue_flag = 'R'
              inventory_transaction_line.item_type = 'I'
              inventory_transaction_line.rec_qty = 1
              inventory_transaction_line.rec_price = catalog_item_price
              inventory_transaction_line.rec_amt = catalog_item_price * 1
              inventory_transaction_line.fill_default_detail_values
              inventory_transaction.max_serial_no = inventory_transaction_line.serial_no = (inventory_transaction.max_serial_no.to_i + 1).to_s if inventory_transaction_line.new_record?
            else
            end
          }
      end
  }   
  inventory_transaction.trans_bk='RE01'
  inventory_transaction.generate_trans_no('INVNRE') if inventory_transaction.new_record?
  inventory_transaction.trans_date = Time.now
   #flexible date format
   date_format = 'standard'
  inventory_transaction.account_period_code = Setup::AccountPeriod.period_from_date(inventory_transaction.trans_date,date_format).code
  inventory_transaction.receipt_issue_flag = 'R'
  inventory_transaction.trans_type = 'O'
  inventory_transaction.remarks = 'Opening inventory import for items'
  #inventory_transaction.company_id = #take input in argument
  inventory_transaction.apply_header_fields_to_lines  
  inventory_transaction.apply_line_fields_to_header  
  inventory = Inventory::InventoryTrans::Posting.new
  inventory_postings = inventory.create_inventory_postings(inventory_transaction)
  save_proc = Proc.new{
    if inventory_transaction.new_record?
      inventory_transaction.save!  
    else
       inventory_transaction.save! 
      inventory_transaction.inventory_transaction_lines.save_line
    end
    Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
  }
  inventory_transaction.save_transaction(&save_proc)
end

end
