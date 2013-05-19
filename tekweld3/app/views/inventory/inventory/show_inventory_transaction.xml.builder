xml.instruct! :xml, :version=>"1.0" 

xml.inventory_transactions{
  for inventory_transaction in @inventory_transactions
    xml.inventory_transaction do
      inventory_transaction.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.inventory_transaction_lines{
        for inventory_transaction_line in inventory_transaction.inventory_transaction_lines
          if inventory_transaction_line.trans_flag == 'A'
            xml.inventory_transaction_line do
              inventory_transaction_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              if inventory_transaction_line.catalog_item
                xml.packet_require_yn(inventory_transaction_line.catalog_item.packet_require_yn)
                xml.image_thumnail(inventory_transaction_line.catalog_item.image_thumnail)
              end
            end
          end
        end
      }
    end
  end
}
