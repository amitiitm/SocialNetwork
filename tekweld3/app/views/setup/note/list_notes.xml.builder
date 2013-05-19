xml.instruct! :xml, :version=>"1.0" 
xml.notes{
  for note in @notes
      xml.note do
        note.id ||= ''
        note.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          xml.tag!(column_name, column_value)
        }   
        xml.user_name(note.user.first_name)  if note.user  
        xml.error(note.errors.on(:base))  if not note.errors.empty?
        xml.error('')  if note.errors.empty?
    end
 end
}
