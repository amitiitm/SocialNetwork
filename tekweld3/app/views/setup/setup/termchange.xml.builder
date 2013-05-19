xml.instruct! :xml, :version=>"1.0" 
xml.terms{
  for term in  @terms
    xml.term do
      if term
        term.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          xml.tag!(column_name, column_value)
        }
        xml.pay1_date(term.pay1_date) if term
      end
    end
  end
}
