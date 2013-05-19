class IndexDstUriLoadBalancers < ActiveRecord::Migration
  def self.up
    add_index :load_balancers, :dst_uri
  end

  def self.down
    remove_index :load_balancers, :dst_uri
  end
end
