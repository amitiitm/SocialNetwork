class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :code, :limit=> 25, :null=>false
      t.string    :role_name, :limit=>50
    end
  end

  def self.down
    drop_table :roles
  end
end
