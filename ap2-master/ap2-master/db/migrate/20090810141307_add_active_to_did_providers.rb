class AddActiveToDidProviders < ActiveRecord::Migration
  def self.up
    add_column :did_providers, :active, :boolean, :default => true
  end

  def self.down
    remove_column :did_providers, :active
  end
end
