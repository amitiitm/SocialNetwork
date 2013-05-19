class AddServerIdToLoadBalancers < ActiveRecord::Migration
  def self.up
    add_column :load_balancers, :server_id, :integer
  end

  def self.down
    remove_column :load_balancers, :server_id
  end
end
