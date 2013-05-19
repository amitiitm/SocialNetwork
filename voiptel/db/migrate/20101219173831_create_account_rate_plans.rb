class CreateAccountRatePlans < ActiveRecord::Migration
  def self.up
    create_table :sip_account_rate_plans do |t|
      t.integer :sip_account_id
      t.integer :rate_plan_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sip_account_rate_plans
  end
end
