class AddForwardableStuffToForwardings < ActiveRecord::Migration
  def self.up
    add_column :forwardings, :forwardable_type, :string, :limit => 20
    add_column :forwardings, :forwardable_id, :integer
  end

  def self.down
    remove_column :forwardings, :forwardable_id
    remove_column :forwardings, :forwardable_type
  end
end
