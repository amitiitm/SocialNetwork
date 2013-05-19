class RemoveExtraFieldsFromCdrs < ActiveRecord::Migration
  def self.up
    remove_column :cdrs, :src_channel
    remove_column :cdrs, :uniqueid
    remove_column :cdrs, :session_log
    remove_column :cdrs, :feedback_id
    remove_column :cdrs, :idid
    remove_column :cdrs, :card_id
    remove_column :cdrs, :tmp_phone_id
    remove_column :cdrs, :dst_channel
    remove_column :cdrs, :billing_duration
  end

  def self.down
    add_column :cdrs, :billing_duration, :integer
    add_column :cdrs, :dst_channel, :string,       :limit => 80
    add_column :cdrs, :tmp_phone_id, :integer
    add_column :cdrs, :card_id, :integer
    add_column :cdrs, :idid, :integer
    add_column :cdrs, :feedback_id, :integer
    add_column :cdrs, :session_log, :string
    add_column :cdrs, :uniqueid, :string,          :limit => 32
    add_column :cdrs, :src_channel, :string,       :limit => 80
  end
end
