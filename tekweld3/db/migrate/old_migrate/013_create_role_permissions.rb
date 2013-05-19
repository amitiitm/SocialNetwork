class CreateRolePermissions < ActiveRecord::Migration
  def self.up
    create_table :role_permissions do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0
      t.integer   :role_id , :null=>false
      t.integer   :document_id, :null=>false
      t.integer   :menu_id, :null=>false
      t.integer   :moodule_id, :null=>false
      t.string    :create_permission, :limit=>1, :default=>'N', :null=>false
      t.string    :modify_permission, :limit=>1, :default=>'N', :null=>false
      t.string    :view_permission, :limit=>1, :default=>'N', :null=>false
    end
  end

  def self.down
    drop_table :role_permissions
  end
end
