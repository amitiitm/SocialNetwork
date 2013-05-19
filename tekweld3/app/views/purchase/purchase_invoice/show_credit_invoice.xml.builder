xml.instruct! :xml, :version=>"1.0" 
xml.purchase_credit_invoices{
  for purchase_credit_invoice in @creditinvoices
    xml.purchase_credit_invoice do
      purchase_credit_invoice.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.purchase_credit_invoice_lines{
        for purchase_credit_invoice_line in purchase_credit_invoice.purchase_credit_invoice_lines
          if purchase_credit_invoice_line.trans_flag == 'A'
            xml.purchase_credit_invoice_line do
              purchase_credit_invoice_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              if purchase_credit_invoice_line.catalog_item
                xml.taxable(purchase_credit_invoice_line.catalog_item.taxable)
                xml.packet_require_yn(purchase_credit_invoice_line.catalog_item.packet_require_yn)
              end
            end
          end
        end
      }
    end
  end
}
