class AlterMeltingTransactionAddPacketReqId < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions, :melting_packet_request_id, :integer
    add_column :melting_transaction_activities, :melting_packet_request_id, :integer
  end

  def self.down
    remove_column :melting_transactions, :melting_packet_request_id
    remove_column :melting_transaction_activities, :melting_packet_request_id
  end
end
