class AddTrunkSettingsToCarriers < ActiveRecord::Migration
  def self.up
    add_column :carriers, :trunk_settings, :text
  end

  def self.down
    remove_column :carriers, :trunk_settings
  end
end
