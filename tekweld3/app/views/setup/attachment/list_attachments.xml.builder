xml.instruct! :xml, :version=>"1.0" 
xml.attachments{
  for attachment in @attachments
    xml.attachment do
      attachment.id ||= ''
      attachment.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }   
      xml.user_name(attachment.user.first_name)  if attachment.user      
      xml.error(attachment.errors)  if not attachment.errors.empty?
      xml.error('')  if attachment.errors.empty?
  end
 end
}
