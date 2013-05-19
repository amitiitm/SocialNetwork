xml.instruct! :xml, :version=>"1.0" 
xml.vendor_payments{
  xml.vendor_payment do
    vendor_payment =  @vendor_payment.first  if @vendor_payment
    if vendor_payment
      vendor_payment.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
        xml.tag!(column_name, column_value)
      }
      xml.name( vendor_payment.name)
      xml.city( vendor_payment.city)
      xml.state( vendor_payment.state)
      xml.zip( vendor_payment.zip)
      xml.phone1(vendor_payment.phone1)
      #      xml.contact1( vendor_payment.contact1)
      #      xml.bank_code{vendor_payment.bank_code}
      xml.vendor_payment_lines do
        vendor_payment.detail_lines.each{|cust_receipt_line| 
          if cust_receipt_line.trans_flag =='A'
            xml.vendor_payment_line do
              cust_receipt_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
                xml.tag!(column_name, column_value)
              }
              xml.remaining_amt(null_to_decimal(cust_receipt_line.balance_amt)-(null_to_decimal(cust_receipt_line.apply_amt)+null_to_decimal(cust_receipt_line.disctaken_amt)) )
              xml.period_close_flag(cust_receipt_line.period_close_flag)
              gl = cust_receipt_line.gl_account
              xml.gl_code(gl.code) if gl
              xml.gl_name(gl.name) if gl
              xml.description(cust_receipt_line.description) 
            end
          end
        }
      end
    end
    xml.gl_transaction_lines do
      if @vendor_payment and @vendor_payment.length > 1
        gl_transactions = @vendor_payment[1]
        gl_transactions.each{|gl_line|
          xml.gl_transaction_line do
            gl_line.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
              xml.tag!(column_name, column_value) 
            }
            xml.serial_no(gl_line.dtl_serial_no)
            xml.gl_code(gl_line.gl_account.code) if gl_line.gl_account
            xml.gl_name(gl_line.gl_account.name) if gl_line.gl_account
          end
        }
      end  
    end
  end
}   

