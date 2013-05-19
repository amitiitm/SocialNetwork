xml.instruct! :xml, :version=>"1.0" 
xml.vendor_invoices{
  xml.vendor_invoice do
    vendor_invoice = @vendor_invoice[0] if @vendor_invoice
    if @vendor_invoice[0]
      vendor_invoice.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
        xml.tag!(column_name, column_value) if column_name!='inv_amt'
      }
      inv_amt = vendor_invoice.inv_amt || 0.00
      xml.inv_amt(inv_amt)
      xml.name( vendor_invoice.name)
      xml.city( vendor_invoice.city)
      xml.state( vendor_invoice.state)
      xml.zip( vendor_invoice.zip)
      xml.phone( vendor_invoice.phone1)
      #    xml.contact1( vendor_invoice.contact1)
      xml.vendor_invoice_lines do
        vendor_invoice.vendor_invoice_lines.applied_lines.each{|vend_invoice_line| 
          xml.vendor_invoice_line do
            vend_invoice_line.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
              xml.tag!(column_name, column_value)
            } 
            #            gl = vend_invoice_line.gl_account
            #            xml.gl_code(gl.code) if gl
            #            xml.gl_name(gl.name) if gl
          end
        }
      end
      xml.gl_transaction_lines do
        if @vendor_invoice and @vendor_invoice.length > 1
          gl_transactions = @vendor_invoice[1]
          if gl_transactions.kind_of?(Array)
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
      xml.vendor_payment_lines do
        if @vendor_invoice and @vendor_invoice.length > 2
          payment_lines = @vendor_invoice[2]
          if payment_lines.kind_of?(Array)
            payment_lines.each{|vend_paym_line| 
              xml.vendor_payment_line do
                vend_paym_line.attributes.each_pair{ |column_name,column_value|
                  column_value = format_column(column_value)
                  column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
                  xml.tag!(column_name, column_value)
                }      
              end
            }
          end
        end
      end
    end     
  end  
}   
