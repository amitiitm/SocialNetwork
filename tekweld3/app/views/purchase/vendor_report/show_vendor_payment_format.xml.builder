xml.instruct! :xml, :version=>"1.0" 
xml.vendor_payments{
   for vendor_payment in @payments
    xml.vendor_payment do
       vendor_payment.attributes.each_pair{ |column_name,column_value|
       column_value = format_column(column_value)
       column_value = sprintf( "%0.02f", column_value) if ((column_name =~ /(.*)amt(.*)/ ) and column_value)     
       column_value = sprintf( "%0.0f", column_value) if ((column_name =~ /(.*)qty(.*)/ ) and column_value)
       xml.tag!(column_name, column_value)
       xml.amt_in_words(convert_num_to_words(column_value)) if ((column_name =~ /(.*)paid_amt(.*)/ ) and column_value)
      }
    xml.vendor_payment_lines{
      for vendor_payment_line in @payment_lines
        xml.vendor_payment_line do
          vendor_payment_line.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          column_value = sprintf( "%0.02f", column_value) if ((column_name =~ /(.*)amt(.*)/ ) and column_value)     
          xml.tag!(column_name, column_value)
          }
        end
      end
      }
    end
 end
}