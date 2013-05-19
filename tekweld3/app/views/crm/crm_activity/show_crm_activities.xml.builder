xml.instruct! :xml, :version=>"1.0" 
xml.crm_activities{
crm_activity = @activity
  xml.crm_activity do 
    if crm_activity     
      crm_activity.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      
      xml.crm_tasks do
          xml.crm_task do
              if task = crm_activity.crm_task 
              task.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
             end 
          end
      end
      
#      xml.crm_opportunities do
#            xml.crm_opportunity do
#             if opportunity = crm_activity.crm_opportunity
#              opportunity.attributes.each_pair{ |column_name,column_value|
#                column_value = format_column(column_value)
#                xml.tag!(column_name, column_value)
#              }
#             end
#          end
#      end      
      
    end
end
}   

