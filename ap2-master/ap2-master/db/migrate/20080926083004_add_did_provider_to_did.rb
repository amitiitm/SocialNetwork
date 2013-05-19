class AddDidProviderToDid < ActiveRecord::Migration
  def self.up
    add_column :dids, :did_provider_id, :integer
  end

  def self.down
    remove_column :dids, :did_provider_id
  end
end
