class AddStatusToActiveJobs < ActiveRecord::Migration
  def self.up
    add_column :active_jobs, :state, :integer, :default => 0
  end

  def self.down
    remove_column :active_jobs, :state
  end
end
