xml.instruct! :xml, :version=>"1.0" 
xml.purchase_memo_returns{
  for purchase_memo_return in @memo_returns
    if purchase_memo_return.line_trans_flag=='A'
      xml.purchase_memo_return do
        purchase_memo_return.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          column_value =  date_format(column_value) if (column_name =~ /(.*)date(.*)/ )
          xml.tag!(column_name, column_value)
        }
      end
    end
  end
}
