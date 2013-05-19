class AddEndpointIdToTrustedEndPoints < ActiveRecord::Migration
  def self.up
    add_column :trusted_endpoints, :endpoint_id, :integer
  end

  def self.down
    remove_column :trusted_endpoints, :endpoint_id
  end
end
