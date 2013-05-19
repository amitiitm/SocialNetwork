class AlterIdColumnInAllTables < ActiveRecord::Migration
#  include ContentModelMethods
#  include ClassMethods 
  include General
  class Type < ActiveRecord::Base; end
  class Menu < ActiveRecord::Base; end
  class Document < ActiveRecord::Base; end
  class Moodule < ActiveRecord::Base; end
  class Role < ActiveRecord::Base; end
#  class UserPermission < ActiveRecord::Base; end
  class RolePermission < ActiveRecord::Base; end
  
  def self.up
    type = Type.find(:first, :select=>'max(id) as maxid')
    maxid = nulltozero(type.maxid) + 1
    execute %{ALTER TABLE types ALTER COLUMN ID RESTART WITH #{maxid}}

    menu = Menu.find(:first, :select=>'max(id) as maxid')
    maxid = nulltozero(menu.maxid) + 1
    execute %{ALTER TABLE menus ALTER COLUMN ID RESTART WITH #{maxid}}

    document = Document.find(:first, :select=>'max(id) as maxid')
    maxid = nulltozero(document.maxid) + 1
    execute %{ALTER TABLE documents ALTER COLUMN ID RESTART WITH #{maxid}}

    moodule = Moodule.find(:first, :select=>'max(id) as maxid')
    maxid = nulltozero(moodule.maxid) + 1
    execute %{ALTER TABLE moodules ALTER COLUMN ID RESTART WITH #{maxid}}

    role = Role.find(:first, :select=>'max(id) as maxid')
    maxid = nulltozero(role.maxid) + 1
    execute %{ALTER TABLE roles ALTER COLUMN ID RESTART WITH #{maxid}}

#    userpermission = UserPermission.find(:first, :select=>'max(id) as maxid')
#    maxid = nulltozero(userpermission.maxid) + 1
#    execute %{ALTER TABLE user_permissions ALTER COLUMN ID RESTART WITH #{maxid}}

    rolepermission = RolePermission.find(:first, :select=>'max(id) as maxid')
    maxid = nulltozero(rolepermission.maxid) + 1
    execute %{ALTER TABLE role_permissions ALTER COLUMN ID RESTART WITH #{maxid}}
  end

  def self.down
  end
end
