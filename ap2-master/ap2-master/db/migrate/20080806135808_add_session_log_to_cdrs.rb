class AddSessionLogToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :session_log, :string
  end

  def self.down
    remove_column :cdrs, :session_log
  end
end
