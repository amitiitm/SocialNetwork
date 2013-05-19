class RemoveExtraFieldsFromCardCdrs < ActiveRecord::Migration
  def self.up
    remove_column :card_cdrs, :uniqueid
    remove_column :card_cdrs, :session_log
    remove_column :card_cdrs, :distributor_id
  end

  def self.down
    add_column :card_cdrs, :distributor_id, :integer
    add_column :card_cdrs, :session_log, :string
    add_column :card_cdrs, :uniqueid, :string,          :limit => 32
  end
end
