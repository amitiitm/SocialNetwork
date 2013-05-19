xml.instruct! :xml, :version=>"1.0" 
xml.role_permissions{
  xml.role_permission {
    xml.company_id(@role_permission[0].company_id)
    xml.role_id(@role_permission[0].role_id)
    xml.role_code(@role_permission[0].role_code)
    xml.updated_by(@role_permission[0].updated_by) 
    xml.created_by(@role_permission[0].created_by)
    xml.role_permission_details {
      for details in @role_permission
        if details.trans_flag !='D'
         then
         xml.role_permission_detail {
          details.attributes.each_pair{ |column_name,column_value|
            column_value = format_column(column_value)
            xml.tag!(column_name, column_value)
          }
          xml.menu_name(details.menu.menu_name) 
        }
        end
      end
    }
  }
}