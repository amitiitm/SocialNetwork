xml.instruct! :xml, :version=>"1.0" 

xml.inventory_transactions{
    for inventory_transaction in @inventory_transactions
    xml.inventory_transaction do
      inventory_transaction.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.inventory_transaction_issue_lines{
        for inventory_transaction_line in inventory_transaction.inventory_transaction_lines
          if inventory_transaction_line.trans_flag == 'A' and inventory_transaction_line.receipt_issue_flag == 'I'
            xml.inventory_transaction_issue_line do
              inventory_transaction_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              xml.image_thumnail(inventory_transaction_line.catalog_item.image_thumnail)
              xml.packet_require_yn(inventory_transaction_line.catalog_item.packet_require_yn)
            end
          end
        end
      }
      xml.inventory_transaction_receive_lines{
        for inventory_transaction_line in inventory_transaction.inventory_transaction_lines
          if inventory_transaction_line.trans_flag == 'A' and inventory_transaction_line.receipt_issue_flag == 'R'
            xml.inventory_transaction_receive_line do
              inventory_transaction_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              xml.image_thumnail(inventory_transaction_line.catalog_item.image_thumnail)
              xml.packet_require_yn(inventory_transaction_line.catalog_item.packet_require_yn)
            end
          end
        end
      }
   end
 end
}
