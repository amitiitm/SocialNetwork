class CreateAccountPeriods < ActiveRecord::Migration
  def self.up
    create_table  :account_periods do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :code,  :limit =>8, :null=>false
      t.string    :gl, :limit =>1, :null=>false, :default=>'C'
      t.string    :ap, :limit =>1, :null=>false, :default=>'C'
      t.string    :ar, :limit =>1, :null=>false, :default=>'C'
      t.string    :description,  :limit =>50
      t.datetime  :from_date, :to_date
      t.string    :ar_post_flag, :limit =>1
      t.string    :ap_post_flag, :limit =>1
      t.string    :gl_post_flag, :limit =>1
      t.integer   :account_year_id
      t.datetime  :in_frdt
      t.datetime  :in_todt
      t.string    :in_post_flag, :limit =>1
      t.string    :iv, :limit =>1
    end
  end

  def self.down
    drop_table :account_periods
  end
end
