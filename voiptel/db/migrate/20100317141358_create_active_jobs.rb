class CreateActiveJobs < ActiveRecord::Migration
  def self.up
    create_table :active_jobs do |t|
      t.string :status, :default => "Initializing"
      t.integer :progress, :default => 0
      t.integer :tasks, :default => 0
      t.boolean :completed, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :active_jobs
  end
end
