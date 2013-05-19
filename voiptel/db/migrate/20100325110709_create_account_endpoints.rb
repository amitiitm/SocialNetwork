class CreateAccountEndpoints < ActiveRecord::Migration
  def self.up
    create_table :account_endpoints do |t|
      t.integer :account_id
      t.integer :endpoint_id

      t.timestamps
    end
    add_index :account_endpoints, :account_id
    add_index :account_endpoints, :endpoint_id
  end

  def self.down
    remove_index :account_endpoints, :endpoint_id
    remove_index :account_endpoints, :account_id
    drop_table :account_endpoints
  end
end
