xml.instruct! :xml, :version=>"1.0"
xml.customer_invoices{
  xml.customer_invoice do
    customer_invoice = @customer_invoice[0] if @customer_invoice
    if @customer_invoice[0]
      customer_invoice.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
        xml.tag!(column_name, column_value) if column_name!='inv_amt'
      }
      inv_amt = customer_invoice.inv_amt || 0.00
      xml.inv_amt(inv_amt)
      xml.name( customer_invoice.name)
      xml.city( customer_invoice.city)
      xml.state( customer_invoice.state)
      xml.zip( customer_invoice.zip)
      xml.phone1( customer_invoice.phone1)
      xml.contact1( customer_invoice.contact1)
      xml.customer_invoice_lines do
        customer_invoice.customer_invoice_lines.applied_lines.each{|cust_invoice_line|
          xml.customer_invoice_line do
            cust_invoice_line.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
              xml.tag!(column_name, column_value)
            }
            xml.gl_code(cust_invoice_line.gl_code)
            xml.gl_name(cust_invoice_line.gl_name)
          end
        }
      end
      xml.gl_transaction_lines do
        if @customer_invoice and @customer_invoice.length > 1
          gl_transactions = @customer_invoice[1]
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
      xml.customer_receipt_lines do
        if @customer_invoice and @customer_invoice.length > 2
          receipt_lines = @customer_invoice[2]
          if receipt_lines.kind_of?(Array)
            receipt_lines.each{|cust_recpt_line|
              xml.customer_receipt_line do
                cust_recpt_line.attributes.each_pair{ |column_name,column_value|
                  column_value = format_column(column_value)
                  column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/  and column_value)
                  xml.tag!(column_name, column_value)
                }
              end
            }
          end
        end
      end
      if !customer_invoice.errors.empty?
        customer_invoice.errors.each {|error,msg|
          xml.error(error,msg)
        }
      end
    end
  end
}
