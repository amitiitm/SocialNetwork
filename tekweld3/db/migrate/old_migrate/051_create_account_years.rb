class CreateAccountYears < ActiveRecord::Migration
  def self.up
    create_table  :account_years do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :year, :limit=>10, :null=>false
      t.string    :from_period, :limit=>8  , :null=>false
      t.string    :to_period, :limit=>8 ,  :null=>false
      t.string    :description, :limit=>50  
      t.string    :ar_flag, :limit=>1  
      t.string    :ap_flag, :limit=>1  
      t.string    :gl_flag, :limit=>1  
    end
  end

  def self.down
    drop_table :account_years
  end
end
