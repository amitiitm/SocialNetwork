class AddIndexesToPbxCdrs < ActiveRecord::Migration
  def self.up
    add_index :pbx_cdrs, :admin_user_id
  end

  def self.down
    remove_index :pbx_cdrs, :admin_user_id
  end
end