xml.instruct! :xml, :version=>"1.0" 
xml.general_ledgers{
   for general_ledger in  @gl_summaries
    xml.general_ledger do
       general_ledger.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      end
 end
}