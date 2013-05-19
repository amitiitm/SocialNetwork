class RenameCallFieldInCdrs < ActiveRecord::Migration
  def self.up
    rename_column :cdrs, :call, :ivr_sec
  end

  def self.down
    rename_column :cdrs, :ivr_sec, :call
  end
end