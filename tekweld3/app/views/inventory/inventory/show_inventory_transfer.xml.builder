xml.instruct! :xml, :version=>"1.0" 

xml.inventory_transfers{
    for inventory_transfer in @inventory_transfers
    xml.inventory_transfer do
      inventory_transfer.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
#      xml.packet_require_yn(inventory_transfer.catalog_item.packet_require_yn)
   end
 end
}
