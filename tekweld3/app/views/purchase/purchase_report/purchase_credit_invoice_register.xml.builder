xml.instruct! :xml, :version=>"1.0" 
xml.purchase_credit_invoices{
  for purchase_credit_invoice in @credit_invoices
    if  purchase_credit_invoice.line_trans_flag=='A'
      xml.purchase_credit_invoice do
        purchase_credit_invoice.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          column_value =  date_format(column_value) if (column_name =~ /(.*)date(.*)/ )
          xml.tag!(column_name, column_value)
        }
      end
    end
  end
}
