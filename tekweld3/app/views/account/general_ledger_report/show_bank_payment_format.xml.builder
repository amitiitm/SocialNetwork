xml.instruct! :xml, :version=>"1.0" 
xml.bank_payments{
   for bank_payment in @payments
    xml.bank_payment do
       bank_payment.attributes.each_pair{ |column_name,column_value|
       column_value = format_column(column_value)
       column_value = sprintf( "%0.02f", column_value) if ((column_name =~ /(.*)amt(.*)/ ) and column_value)     
       column_value = sprintf( "%0.0f", column_value) if ((column_name =~ /(.*)qty(.*)/ ) and column_value)
       xml.tag!(column_name, column_value)
       xml.amt_in_words(convert_num_to_words(column_value)) if ((column_name =~ /(.*)debit_amt(.*)/ ) and column_value)
      }
    xml.bank_payment_lines{
      for bank_payment_line in @payment_lines
        xml.bank_payment_line do
          bank_payment_line.attributes.each_pair{ |column_name,column_value|
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