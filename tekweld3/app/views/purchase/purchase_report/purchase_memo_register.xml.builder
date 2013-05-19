xml.instruct! :xml, :version=>"1.0" 
xml.purchase_memos{
  for purchase_memo in @memos
    if purchase_memo.line_trans_flag=='A'
      xml.purchase_memo do
        purchase_memo.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          column_value =  date_format(column_value) if (column_name =~ /(.*)date(.*)/ )
          xml.tag!(column_name, column_value)
        }
      end
    end
  end
}
