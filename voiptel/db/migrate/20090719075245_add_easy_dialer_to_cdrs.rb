class AddEasyDialerToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :easy_dialer, :boolean
  end

  def self.down
    remove_column :cdrs, :easy_dialer
  end
end
