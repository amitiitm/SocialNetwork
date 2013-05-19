class CreateCrmOpportunities < ActiveRecord::Migration
  def self.up
    create_table :crm_opportunities do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :name,:opportunity_type,:stage, :limit=>50
      t.integer   :crm_account_id
      t.datetime  :close_date
      t.decimal   :probability_per,  :precision=>6, :scale=>2, :default=>0
      t.decimal   :amount,  :precision=>12, :scale=>2, :default=>0
      t.string    :subject, :description, :limit=>100
    end
  end

  def self.down
    drop_table :crm_opportunities
  end
end
