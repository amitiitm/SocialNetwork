class Admin::MenuCrud
include General
  
def self.list_of_menu_items(doc)
  criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
  Adim::Menu.find(:all, :joins => :moodule,
                  :conditions => ["menus.code between '#{criteria.str1}' and '#{criteria.str2}' AND
                                  menu_name between '#{criteria.str3}' and '#{criteria.str4}' AND
                                  menus.trans_flag between '#{criteria.str5[0,1]}' and '#{criteria.str6[0,1]}' AND
                                  moodules.code between '#{criteria.str7}' and '#{criteria.str8}'
                                  "
                                   ],
                   :select => "menus.*, moodules.code as moodule_code"
  )    
end

def self.find_documents_not_in_menu()
  sql = "id not in (select nvl(document_id,0) from menus where upper(trans_flag) = 'A')"
  sql = convert_sql_to_db_specific(sql)
  Admin::Document.activedocuments.find(:all,
                        :conditions => [sql],
                        :select => "distinct documents.*"
                      )
end

def self.populate_moodules
  Admin::Moodule.activemoodules
end

def self.find_menu_items(doc)
  moodule_id =  parse_xml(doc/:criteria/'moodule_id')   if (doc/:criteria/'moodule_id').first
  Admin::Menu.activemenu.find_all_by_moodule_id_and_menu_type(moodule_id,'M') if moodule_id
end

#def self.create_menu(doc)
#  error = 'N'
#  sub_menus,deleted_rows = add_new_menu(doc)
#  begin
#    Admin::Menu.transaction() do  
#      deleted_rows.each{|dm|
#        dm.update_attributes(:trans_flag => 'D') 
#        remove_role_permissions(dm)
#        }   
#       sub_menus.each {|menu|
#        menu.save!  
#      }
#    end
#    rescue Exception
#      error = 'T'
#  end  
#  error
#end  

def self.add_new_menu(doc)
  sub_menus = []
  old_rows = []
  new_rows = []
  moodule_id = parse_xml(doc/:menus/'moodule_id')  if (doc/:menus/'moodule_id').first
  company_id = parse_xml(doc/:menus/'company_id')  if (doc/:menus/'company_id').first
  (doc/:menus/:menu).each { |xml_menu|
    menu_id = parse_xml(xml_menu/'menu_id')  if (xml_menu/'menu_id').first
    (xml_menu/:sub_menu).each { |xml_submenu|
      sm = add_menu_item(xml_submenu,menu_id, moodule_id,company_id)
      sm.new_record? ? new_rows << sm : old_rows << sm 
      sub_menus << sm
      }
     }  
  existing_menu = Admin::Menu.activemenu.find_all_by_moodule_id_and_menu_type(moodule_id,'S')
  deleted_rows =  existing_menu - old_rows
  
  return sub_menus, deleted_rows
end

def self.add_menu_item(submenu_item, menu_id,moodule_id,company_id)
  submenu_id = parse_xml(submenu_item/'id')  if  (submenu_item/'id').first
#  if submenu_id != nil
#    if submenu = Admin::Menu.find_by_id(submenu_id) 
#      submenu.menu_id = menu_id if not submenu.menu_id = menu_id
#    end
#  else
#    submenu = Admin::Menu.new
#  end
  submenu = Admin::Menu.find_or_create(submenu_id)  
  submenu.menu_id = menu_id if not submenu.menu_id == menu_id and submenu
  
  if submenu.new_record? 
    submenu.moodule_id = moodule_id
    submenu.company_id = company_id
    submenu.document_id = parse_xml(submenu_item/'document_id')  if parse_xml(submenu_item/'document_id')
    document = Admin::Document.find_by_id(submenu.document_id) if submenu.document_id
    submenu.menu_name = document.document_name if document
    submenu.code = document.code if document
    submenu.menu_type= 'S'
    submenu.menu_id = menu_id
  end
  submenu
  end
  
def self.remove_role_permissions(menu)
  if rp = Admin::RolePermission.find_by_menu_id(menu.id)
   Admin::RolePermission.delete(rp)
  end
end

#### start of new code
def self.list_menus(doc)
  criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
  menu_list = Admin::Menu.find(:all,
                    :joins => "inner join moodules on menus.moodule_id=moodules.id
                              inner join menus m on menus.menu_id=m.id ",
                    :conditions => ["(menus.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} )or (menus.code in ('#{criteria.multiselect1}'))) AND
                                    (menus.menu_name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} )or (menus.menu_name in ('#{criteria.multiselect2}'))) AND
                                    (menus.menu_type between '#{criteria.str9}' and '#{criteria.str10}' AND (0 =#{criteria.multiselect5.length} )or (menus.menu_type in ('#{criteria.multiselect5}'))) AND
                                    (m.menu_name between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} )or (m.menu_name in ('#{criteria.multiselect3}'))) AND
                                    (moodules.moodule_name between '#{criteria.str7}' and '#{criteria.str8}' AND (0 =#{criteria.multiselect4.length} )or (moodules.moodule_name in ('#{criteria.multiselect4}')))
                                    " ],
                    :order => "id"
                    
                    
  )
 menu_list
end

def self.create_menus(doc)
 menus = [] 
 (doc/:menus/:menu).each{|doc_type|
   menu = create_menu(doc_type)
    menus <<  menu if menu
  }
  menus
end

def self.create_menu(doc)
  menu = add_or_modify_menu(doc) 
  return  if !menu
  save_proc = Proc.new{
      menu.save! 
    }
  menu.save_master(&save_proc)
  return  menu
end

def self.add_or_modify_menu(doc)
  id =  parse_xml(doc/'id') if (doc/'id').first  
  menu = Admin::Menu.find_or_create(id) 
  return if !menu
  menu.apply_attributes(doc) 
  # Add a block to set details
  
  return menu
end

def self.show_menu(id)
 Admin::Menu.find_all_by_id(id)
end

 def self.list_moodules(doc)
  criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
  moodule_list = Admin::Moodule.find(:all,
                    
                    :conditions => ["(moodules.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} )or (moodules.code in ('#{criteria.multiselect1}'))) AND
                                      (moodules.moodule_name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} )or (moodules.moodule_name in ('#{criteria.multiselect2}')))
                                    " ],
                    :order => "id"
                    
                    
  )
 moodule_list
end

def self.create_moodules(doc)
 moodules = [] 
 (doc/:moodules/:moodule).each{|doc_type|
   moodule = create_moodule(doc_type)
    moodules <<  moodule if moodule
  }
  moodules
end

def self.create_moodule(doc)
  moodule = add_or_modify_moodule(doc) 
  return  if !moodule
  save_proc = Proc.new{
      moodule.save! 
    }
  moodule.save_master(&save_proc)
  return  moodule
end

def self.add_or_modify_moodule(doc)
  id =  parse_xml(doc/'id') if (doc/'id').first  
  moodule = Admin::Moodule.find_or_create(id) 
  return if !moodule
  moodule.apply_attributes(doc) 
  # Add a block to set details
  
  return moodule
end

def self.show_moodule(id)
 Admin::Moodule.find_all_by_id(id)
end

end