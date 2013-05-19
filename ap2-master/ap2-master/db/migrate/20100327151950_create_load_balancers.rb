class CreateLoadBalancers < ActiveRecord::Migration
  def self.up
    create_table :load_balancers do |t|
      t.integer :group_id
      t.string :dst_uri
      t.string :resources
      t.integer :probe_mode
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :load_balancers
  end
end
