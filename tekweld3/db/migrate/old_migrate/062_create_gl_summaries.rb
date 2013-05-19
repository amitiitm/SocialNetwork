class CreateGlSummaries < ActiveRecord::Migration
  def self.up
     create_table :gl_summaries do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :account_period_code, :limit=>8
      t.integer   :gl_account_id
      t.decimal   :debit_amt, :credit_amt , :precision=>12, :scale=>2
    end
  end

  def self.down
     drop_table :gl_summaries
  end
end
