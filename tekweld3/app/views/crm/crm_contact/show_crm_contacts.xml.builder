xml.instruct! :xml, :version=>"1.0" 
xml.crm_contacts{
crm_contact = @contact
  xml.crm_contact do
#    crm_contact =  @contacts.first  
    if crm_contact
      crm_contact.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
       xml.crm_addresses do
#        crm_address = @contacts[1] if @contacts.length > 1
        crm_contact.crm_addresses.each{|line| 
          if line.trans_flag =='A'
            xml.crm_address do
              line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
             end
            end
        }
        end
      end
end
}   

