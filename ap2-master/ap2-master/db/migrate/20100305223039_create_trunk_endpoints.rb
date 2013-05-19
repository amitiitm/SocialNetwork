class CreateTrunkEndpoints < ActiveRecord::Migration
  def self.up
    create_table :trunk_endpoints do |t|
      t.integer :trunk_id
      t.integer :endpoint_id

      t.timestamps
    end
    add_index :trunk_endpoints, :trunk_id
    add_index :trunk_endpoints, :endpoint_id
  end

  def self.down
    remove_index :trunk_endpoints, :endpoint_id
    remove_index :trunk_endpoints, :trunk_id
    drop_table :trunk_endpoints
  end
end
