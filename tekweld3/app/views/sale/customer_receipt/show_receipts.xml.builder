xml.instruct! :xml, :version=>"1.0" 
xml.customer_receipts{
  xml.customer_receipt do
    customer_receipt =  @customer_receipt.first  if @customer_receipt
    if customer_receipt
      customer_receipt.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
        xml.tag!(column_name, column_value)
      }
      xml.name( customer_receipt.name)
      xml.city( customer_receipt.city)
      xml.state( customer_receipt.state)
      xml.zip( customer_receipt.zip)
      xml.phone1(customer_receipt.phone1)
      xml.contact1( customer_receipt.contact1)
      #      xml.bank_code{customer_receipt.bank_code}
      xml.customer_receipt_lines do
        customer_receipt.detail_lines.each{|cust_receipt_line| 
          if cust_receipt_line.trans_flag =='A'
            xml.customer_receipt_line do
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
      if @customer_receipt and @customer_receipt.length > 1
        gl_transactions = @customer_receipt[1]  
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
    if !customer_receipt.errors.empty?
      customer_receipt.errors.each {|error,msg| 
        xml.error(error,msg) 
      }
    end      
  end
}   

