class AddCallAndSessionIdToCardCdrs < ActiveRecord::Migration
  def self.up
    add_column :card_cdrs, :call_id, :string, :limit => 64
    add_column :card_cdrs, :session_id, :string, :limit => 10
  end

  def self.down
    remove_column :card_cdrs, :session_id
    remove_column :card_cdrs, :call_id
  end
end
