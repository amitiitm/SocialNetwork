class Admin::RolePermission < ActiveRecord::Base
  include UserStamp
  include Dbobject
  require 'has_finder'
 
  belongs_to:role
  belongs_to:menu
  belongs_to:document
  belongs_to:moodule
  scope :moodule_list ,lambda{|user_id|{ :joins=> " inner join user_permissions on (user_permissions.role_id = role_permissions.role_id
                                                        
                                              and user_permissions.trans_flag = 'A')
                                inner join moodules on (moodules.id = role_permissions.moodule_id and  moodules.trans_flag='A' )            ", 
      :conditions => ["user_id = ?",user_id],:select => "distinct moodule_id" ,:order => "moodule_id"}}
  scope :activerolepermissions, :conditions => { :trans_flag => 'A' }

  validates :menu_id, :moodule_id,:presence => true

  def apply_top_menu_role_permission(doc,idd)
    if(parse_xml(doc/'trans_flag') == 'D')
      if(Admin::RolePermission.find_by_sql("select menus.id from role_permissions
                                            inner join menus on role_permissions.menu_id=menus.id
                                            where menus.menu_id=#{idd.menu_id} and
                                                  role_permissions.role_id=#{parse_xml(doc/'role_id')} and
                                                  role_permissions.menu_id <> #{parse_xml(doc/'menu_id')} and
                                                  role_permissions.trans_flag='A'").length>0)
        self.trans_flag = 'A'
      else
        self.trans_flag = 'D'
      end
    end
    self.menu_id            = idd.menu_id
    self.role_id            = parse_xml(doc/'role_id')
    self.moodule_id         = idd['moodule_id']
    self.document_id        = 0
    self.create_permission  = 'Y'
    self.modify_permission  = 'Y'
    self.view_permission    = 'Y'
    self
  end
end
