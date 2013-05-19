xml.instruct! :xml, :version=>"1.0" 
xml.diamond_packets{
   for diamond_packet in @diamond_packet
    xml.diamond_packet do
       diamond_packet.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.stone_type(diamond_packet.diamond_lot.stone_type) if diamond_packet.diamond_lot
      xml.diamond_lot_number(diamond_packet.diamond_lot.lot_number) if diamond_packet.diamond_lot
      xml.diamond_cert_flag(diamond_packet.diamond_lot.cert_flag) if diamond_packet.diamond_lot
    end
 end
}
