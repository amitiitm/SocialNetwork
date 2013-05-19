class AddRatePlanIdToSipAccounts < ActiveRecord::Migration
  def self.up
    add_column :subscriber, :rate_plan_id, :integer
  end

  def self.down
    remove_column :subscriber, :rate_plan_id
  end
end