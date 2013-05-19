class CreateUserCompanies < ActiveRecord::Migration
  def self.up
    create_table :user_companies do |t|
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :user_id, :null=>false
      t.integer   :company_id, :null=>false
    end
  end

  def self.down
    drop_table :user_companies
  end
end
