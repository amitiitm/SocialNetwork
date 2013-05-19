xml.instruct! :xml, :version=>"1.0" 
xml.types{
  xml.type{
    xml.details{
      for type in @types
        if type.trans_flag=='A'
        xml.detail do
          type.attributes.each_pair{ |column_name,column_value|
            column_value = format_column(column_value)
            xml.tag!(column_name, column_value)
          }
          end
        end
      end
    }
  }
}