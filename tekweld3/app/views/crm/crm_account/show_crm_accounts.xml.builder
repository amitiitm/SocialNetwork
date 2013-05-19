xml.instruct! :xml, :version=>"1.0" 
xml.crm_accounts{
  crm_account = @account
  xml.crm_account do 
    if crm_account
      
      crm_account.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.crm_addresses do
        crm_account.crm_addresses.each{|line| 
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
     
      
      xml.crm_tasks do
        crm_account.crm_tasks.each{|line| 
          if line.trans_flag =='A'
            xml.crm_task do
              line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value) 
              }
              xml.crm_account_name(line.crm_account.name) if line.crm_account
              xml.crm_contact_code(line.crm_contact.first_name + " "+line.crm_contact.last_name) if line.crm_contact
              xml.assigned_user_name(line.user.first_name) if line.user
            end
          end
        }
      end
      
      xml.crm_contacts do
        crm_account.crm_contacts.each{|line| 
          if line.trans_flag =='A'
            xml.crm_contact do
              line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value) 
              }
            end
          end
        }
      end
     
      xml.crm_opportunities do
        crm_account.crm_opportunities.each{|line| 
          if line.trans_flag =='A'
            xml.crm_opportunity do
              line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        }
      end      
      
      xml.crm_activities do
        crm_account.crm_activities.each{|line| 
          if line.trans_flag =='A'
            xml.crm_activity do
              line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value) 
              }
              xml.crm_account_name(line.crm_account.name) if line.crm_account
              xml.crm_contact_code(line.crm_contact.first_name + " "+ line.crm_contact.last_name) if line.crm_contact
              xml.performed_user_name(line.user.first_name) if line.user
            end
          end
        }
      end      
      
    end
  end
}   
