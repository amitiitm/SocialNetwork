xml.instruct! :xml, :version=>"1.0" 
xml.role_permissions{
  xml.role_permission {
    xml.company_id(@user_permission[0].company_id) 
    xml.updated_by(@user_permission[0].updated_by) 
    xml.created_by(@user_permission[0].created_by)
    xml.user_roles {
      for details in @user_permission
        if details.trans_flag !='D'
        xml.user_role {
          details.attributes.each_pair{ |column_name,column_value|
            column_value = format_column(column_value)
            xml.tag!(column_name, column_value)
          }
          xml.name(details.user.first_name)
        }
        end
      end
    }
  }
}
