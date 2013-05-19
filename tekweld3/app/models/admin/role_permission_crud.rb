class Admin::RolePermissionCrud
  include General

  def self.populate_roles
    Admin::Role.activeroles
  end

  def self.get_unassigned_menus
    Admin::Moodule.activemoodules
  end

  def self.get_role_submenus(role_id)
    Admin::RolePermission.activerolepermissions.find(:all,:joins => :menu,
      :conditions => ["menus.menu_type = 'S' and role_id = #{role_id} and upper(menus.trans_flag) = 'A'"
        ])
  end

  def self.list_user_permissions(user_id)
    Admin::RolePermission.find_by_sql ["select ds.component_cd as component_cd, ds.id as document_id,
                                        max(rp.create_permission) as create_permission,
                                        max(rp.modify_permission) as modify_permission,
                                        max(rp.view_permission) as view_permission
                                        from user_permissions up, role_permissions rp, documents ds
                                        where up.role_id = rp.role_id
                                        and user_id = #{user_id}
                                        and rp.document_id = ds.id
                                        group by ds.component_cd, ds.id
      "]

  end

  #def self.create_role_permissions(doc)
  #  deleted_rows,new_rows, old_rows = add_new_permissions(doc)
  #  begin
  #    Admin::RolePermission.transaction() do
  #      deleted_rows.each{|dp|
  #        Admin::RolePermission.delete(dp)
  #        }
  #      new_rows.each {|rpm|
  #        rpm.save!
  #        }
  #      old_rows.each {|orp|
  #        orp.save!
  #        }
  #    end
  #    rescue Exception
  #      error = 'Y'
  #  else
  #   error = 'N'
  #  end
  #  error
  #end
  #
  #def self.add_new_permissions(doc)
  #  role_id = 0
  #  old_rows = []
  #  new_rows = []
  #  deleted_rows = []
  #  (doc/:role_permissions/:role_permission).each { |permission_doc|
  #    rp = add_permissions(permission_doc)
  #    role_id = rp.role_id
  #    rp.new_record? ? new_rows << rp : old_rows << rp
  #    }
  #  role_permissions = self.get_role_submenus(role_id)
  #  deleted_rows =  role_permissions - old_rows
  #
  #  return deleted_rows,new_rows , old_rows
  #end
  #
  #def self.add_permissions(sub_menu_doc)
  #  permission_id = parse_xml(sub_menu_doc/'permission_id')  if  (sub_menu_doc/'permission_id').first
  #  rp = Admin::RolePermission.find_or_create(permission_id)
  #  if rp.new_record?
  #    rp.role_id = parse_xml(sub_menu_doc/'role_id')  if  (sub_menu_doc/'role_id').first
  #    rp.company_id = parse_xml(sub_menu_doc/'company_id')  if  (sub_menu_doc/'company_id').first
  #    rp.menu_id =  parse_xml(sub_menu_doc/'menu_id')  if (sub_menu_doc/'menu_id').first
  #    menu = Admin::Menu.find_by_id(rp.menu_id) if rp.menu_id
  #    rp.document_id = menu.document_id if menu
  #    rp.moodule_id = menu.moodule_id if menu
  #  end
  #  rp.create_permission = parse_xml(sub_menu_doc/'create_permission')  if  (sub_menu_doc/'create_permission').first
  #  rp.modify_permission = parse_xml(sub_menu_doc/'modify_permission')  if  (sub_menu_doc/'modify_permission').first
  #  rp.view_permission = parse_xml(sub_menu_doc/'view_permission')  if  (sub_menu_doc/'view_permission').first
  #  rp
  #end

  ### start of new code
  def self.create_role_permissions(doc)

    (doc/:role_permissions/:role_permission).each{|doc_type|
      @role_permissions = create_role_permission(doc_type)
      #    role_permissions <<  role_permission if role_permission
    }
    return @role_permissions
  end

  def self.create_role_permission(doc)
    role_permissions = []
    company_id=parse_xml(doc/'company_id')
    updated_by=parse_xml(doc/'updated_by')
    created_by=parse_xml(doc/'created_by')
    (doc/:role_permission_details/:role_permission_detail).each{|doc_type|
      role_permission,top_menu_role_permission = add_or_modify_role_permission(doc_type)
      return  if !role_permission
      role_permission.company_id = top_menu_role_permission.company_id = company_id
      role_permission.updated_by = top_menu_role_permission.updated_by = updated_by
      role_permission.created_by = created_by
      top_menu_role_permission.created_by = created_by if(top_menu_role_permission.new_record?)
      role_permission.save
      top_menu_role_permission.save
      role_permissions << role_permission
    }
    return  role_permissions
  end

  def self.add_or_modify_role_permission(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    menu_obj = Admin::Menu.find_by_id(parse_xml(doc/'menu_id'))
    role_permission = Admin::RolePermission.find_or_create(id)
    return if !role_permission
    if (id.empty? or id.to_i == 0)
      then
      role_permission.moodule_id = menu_obj['moodule_id']
      role_permission.document_id = menu_obj['document_id']
    end
    lock_version = role_permission.lock_version
    role_permission.apply_attributes(doc)
    role_permission.lock_version = lock_version
    top_menu_role_permission = Admin::RolePermission.find_or_create_by_role_id_and_menu_id_and_trans_flag(parse_xml(doc/'role_id'),menu_obj.menu_id,'A')
    top_menu_role_permission.apply_top_menu_role_permission(doc,menu_obj)
    return role_permission, top_menu_role_permission
  end

end
