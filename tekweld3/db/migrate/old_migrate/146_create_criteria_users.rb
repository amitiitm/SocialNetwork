class CreateCriteriaUsers < ActiveRecord::Migration
  def self.up
    create_table  :criteria_users do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :criteria_id, :null=>false
      t.integer   :user_id,  :null=>false
      t.integer   :document_id,  :null=>false
      t.string    :default_yn, :limit=>1, :default=>'N'     
    end
  end

  def self.down
    drop_table :criteria_users
  end
end
