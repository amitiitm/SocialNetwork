class RemoveDatesFromNumberingPlans < ActiveRecord::Migration
  def self.up
    remove_column :numbering_plans, :created_at
    remove_column :numbering_plans, :updated_at
  end

  def self.down
  end
end
