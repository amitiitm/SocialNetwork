class CreateTrustedEndpoints < ActiveRecord::Migration
  def self.up
    create_table :trusted_endpoints do |t|
      t.integer :grp
      t.string :ip
      t.integer :mask
      t.integer :port
      t.string :proto
      t.string :pattern
      t.string :context_info

      t.timestamps
    end
  end

  def self.down
    drop_table :trusted_endpoints
  end
end
