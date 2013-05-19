class AddArchivedToCarriers < ActiveRecord::Migration
  def self.up
    add_column :carriers, :archived, :boolean, :default => 0
  end

  def self.down
    remove_column :carriers, :archived
  end
end
