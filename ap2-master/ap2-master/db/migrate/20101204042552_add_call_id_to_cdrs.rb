class AddCallIdToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :call_id, :string, :limit => 64, :default => ""
    add_column :cdrs, :session_id, :string, :limit => 32, :default => ""
  end

  def self.down
    remove_column :cdrs, :session_id
    remove_column :cdrs, :call_id
  end
end