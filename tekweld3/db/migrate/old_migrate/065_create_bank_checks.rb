class CreateBankChecks < ActiveRecord::Migration
  def self.up
     create_table :bank_checks do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :bank_id, :check_from, :check_to
      t.string    :payment_type, :limit=>25
    end
  end

  def self.down
    drop_table :bank_checks
  end
end
