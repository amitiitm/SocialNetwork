xml.instruct! :xml, :version=>"1.0" 
xml.url{
  xml.result(@result)
}
#xml.instruct! :xml, :version=>"1.0" 
#xml.credit_invoices{
#   for vendor_credit_invoice in @invoices
#    xml.credit_invoice do
#       vendor_credit_invoice.attributes.each_pair{ |column_name,column_value|
#       column_value = format_column(column_value)
#       column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ )     
#       column_value = sprintf( "%0.0f", column_value) if (column_name =~ /(.*)qty(.*)/ )
#       xml.tag!(column_name, column_value)
#      }
#    xml.credit_invoice_lines{
#      for vendor_credit_invoice_line in @invoice_lines
#        xml.credit_invoice_line do
#          vendor_credit_invoice_line.attributes.each_pair{ |column_name,column_value|
#          column_value = format_column(column_value)
#          column_value = sprintf( "%0.02f", column_value) if (column_name =~ /(.*)amt(.*)/ )     
#          xml.tag!(column_name, column_value)
#          }
#        end
#      end
#      }
#    end
# end
#}