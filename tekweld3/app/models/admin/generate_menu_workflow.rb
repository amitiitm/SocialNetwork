class Admin::GenerateMenuWorkflow
  include General
  
  def self.list_moodules(user_id)
    Admin::RolePermission.activerolepermissions.moodule_list user_id
  end
  
  def self.get_menu_list(doc)
    user_id = parse_xml(doc/:params/'id')   if (doc/:params/'id').first
    menu_list = Admin::Menu.find(:all, 
      :joins => "inner join role_permissions on (menus.id = role_permissions.menu_id and role_permissions.trans_flag = 'A')
                          left outer join documents on (menus.document_id = documents.id and documents.trans_flag = 'A' 
                          and menus.document_id <> 0)",
      :conditions => ["role_permissions.role_id in (select role_id from user_permissions where user_id = ?
                                                             and trans_flag = 'A')
                              and menus.trans_flag = 'A'",
        user_id],
      :select => " distinct menus.*, documents.component_cd, 
                           role_permissions.document_id,role_permissions.create_permission,
                            role_permissions.modify_permission,role_permissions.view_permission",
      :order => "menus.sequence"
    )
    menu_list
  end
  
#  def self.get_menu_list(doc)
#    user_id = parse_xml(doc/:params/'id')   if (doc/:params/'id').first
#    condition = "role_permissions.role_id in (select role_id from user_permissions where user_id = ?
#                 and trans_flag = 'A') and menus.trans_flag = 'A'"
#    condition = convert_sql_to_db_specific(condition)
#    Admin::Menu.find_by_sql ["select CAST((
#                              select(select distinct menus.id,menus.code,menus.menu_name as name,menus.moodule_id,menus.sequence,
#				case documents.component_cd
#					when documents.component_cd then documents.component_cd
#				else
#					 ''
#                                end as component_cd,
#                                case role_permissions.document_id
#					when role_permissions.document_id then role_permissions.document_id
#				else
#					 ''
#                                end as document_id,
#				role_permissions.create_permission,
#				role_permissions.modify_permission,role_permissions.view_permission from menus
#				inner join role_permissions on (menus.id = role_permissions.menu_id and role_permissions.trans_flag = 'A')
#				left outer join documents on (menus.document_id = documents.id and documents.trans_flag = 'A' 
#				and menus.document_id <> 0)
#                                where #{condition} order by menus.sequence
#                                FOR XML PATH('rolepermission'), TYPE,ELEMENTS XSINIL
#                                )FOR XML PATH('rolepermissions')) AS varchar(MAX)) as XMLCOL",
#      user_id
#    ]
#  end
end
