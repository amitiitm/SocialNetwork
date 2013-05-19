class AddServerIdToTrustedEndpoints < ActiveRecord::Migration
  def self.up
    add_column :trusted_endpoints, :server_id, :integer
  end

  def self.down
    remove_column :trusted_endpoints, :server_id
  end
end
