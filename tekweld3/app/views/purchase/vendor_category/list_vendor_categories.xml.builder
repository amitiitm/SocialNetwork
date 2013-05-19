xml.instruct! :xml, :version=>"1.0" 
xml.vendor_categories{
   for vendor_category in @vendor_categories
    xml.vendor_category do
       vendor_category.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.gl_account_payable_code(vendor_category.gl_account_payable.code) if vendor_category.gl_account_payable
      xml.gl_account_expense_code(vendor_category.gl_account_expense.code) if vendor_category.gl_account_expense
    end
 end
}

