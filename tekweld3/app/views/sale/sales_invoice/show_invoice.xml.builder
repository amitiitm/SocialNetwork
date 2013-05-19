xml.instruct! :xml, :version=>"1.0" 
xml.sales_invoices{
  for sales_invoice in @invoices
    xml.sales_invoice do
      sales_invoice.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.sales_invoice_lines{
        for sales_invoice_line in sales_invoice.sales_invoice_lines
          if sales_invoice_line.trans_flag == 'A'
            xml.sales_invoice_line do
              sales_invoice_line.attributes.each_pair{ |column_name,column_value|
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
