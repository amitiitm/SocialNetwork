class RenameEasyDialerToUsedEasyDialerInCdrs < ActiveRecord::Migration
  def self.up
    rename_column :cdrs, :easy_dialer, :used_easy_dialer
  end

  def self.down
    rename_column :cdrs, :used_easy_dialer, :easy_dialer
  end
end
