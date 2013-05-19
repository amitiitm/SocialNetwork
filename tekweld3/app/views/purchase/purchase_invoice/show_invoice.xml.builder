xml.instruct! :xml, :version=>"1.0" 
xml.purchase_invoices{
  for purchase_invoice in @invoices
    xml.purchase_invoice do
      purchase_invoice.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.purchase_invoice_lines{
        for purchase_invoice_line in purchase_invoice.purchase_invoice_lines
          if purchase_invoice_line.trans_flag == 'A'
            xml.purchase_invoice_line do
              purchase_invoice_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
   
              if purchase_invoice_line.catalog_item
                xml.taxable(purchase_invoice_line.catalog_item.taxable)
                xml.packet_require_yn(purchase_invoice_line.catalog_item.packet_require_yn)
                xml.image_thumnail(purchase_invoice_line.catalog_item.image_thumnail)
              end
            end
          end
        end
      }
    end
  end
}
