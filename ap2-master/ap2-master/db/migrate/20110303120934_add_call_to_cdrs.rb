class AddCallToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :call, :integer, :limit => 1, :default => 1
  end

  def self.down
    remove_column :cdrs, :call
  end
end
