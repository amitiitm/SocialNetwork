class CreateBanks < ActiveRecord::Migration
 def self.up
    create_table :banks do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :code,  :limit=>25
      t.string    :name, :address1, :address2, :limit=>50
      t.string    :bank_acct_no, :transit_no, :contact_nm, :limit=>30
      t.string    :city,:country, :limit=>20
      t.string    :zip, :limit=>15
      t.string    :state, :limit=>25
      t.string    :payment_type, :limit=>25
      t.integer   :gl_category_id
      t.datetime  :start_date
      t.string    :account_type,:balance_type, :limit=>2
      t.decimal   :credit_limit , :precision=>12, :scale=>2
    end
  end

  def self.down
    drop_table :banks
  end
end
