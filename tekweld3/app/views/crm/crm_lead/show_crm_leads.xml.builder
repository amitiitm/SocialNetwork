xml.instruct! :xml, :version=>"1.0" 
xml.crm_leads{
  for crm_lead in  @crm_leads
    xml.crm_lead do
      crm_lead.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.lead_notes{
        for lead_note in crm_lead.lead_notess
          if lead_note.trans_flag == 'A'
            xml.lead_note do
              lead_note.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
            end
          end
        end
      }
    end
  end
}