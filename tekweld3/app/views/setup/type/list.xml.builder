xml.instruct! :xml, :version=>"1.0" 
xml.data{
  for list in @listarray
      xml.tag!(list[0].type_cd.downcase) do
        for listitem in list
          xml.tag!(listitem.subtype_cd.downcase){
            xml.tag!('label', listitem.description)
            xml.tag!('value', listitem.value)
          }
        end
      end
  end
}
