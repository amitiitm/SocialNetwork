class AddHasRatesToRateGroups < ActiveRecord::Migration
  def self.up
    add_column :rate_groups, :has_rates, :boolean
  end

  def self.down
    remove_column :rate_groups, :has_rates
  end
end
