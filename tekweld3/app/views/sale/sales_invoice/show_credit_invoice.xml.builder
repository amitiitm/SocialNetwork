xml.instruct! :xml, :version=>"1.0" 
xml.sales_credit_invoices{
  for sales_credit_invoice in @creditinvoices
    xml.sales_credit_invoice do
      sales_credit_invoice.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.sales_credit_invoice_lines{
        for sales_credit_invoice_line in sales_credit_invoice.sales_credit_invoice_lines
          if sales_credit_invoice_line.trans_flag == 'A'
            xml.sales_credit_invoice_line do
              sales_credit_invoice_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
    end
  end
}
