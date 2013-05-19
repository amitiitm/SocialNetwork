class CreateJobUpdates < ActiveRecord::Migration
  def self.up
    create_table :job_updates do |t|
      t.string :key, :limit => 30

      t.timestamps
    end
  end

  def self.down
    drop_table :job_updates
  end
end
