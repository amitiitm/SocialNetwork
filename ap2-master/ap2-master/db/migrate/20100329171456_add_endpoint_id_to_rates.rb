class AddEndpointIdToRates < ActiveRecord::Migration
  def self.up
    add_column :rates, :endpoint_id, :integer
  end

  def self.down
    remove_column :rates, :endpoint_id
  end
end
