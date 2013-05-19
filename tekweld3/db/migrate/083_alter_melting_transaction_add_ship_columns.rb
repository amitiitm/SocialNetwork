class AlterMeltingTransactionAddShipColumns < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions, :shippacket_ship_via,:string, :limit=>25  
    add_column :melting_transactions, :shippacket_tracking_no,:string, :limit=>25  
    add_column :melting_transactions, :shippacketsend,:string, :limit=>1  
    add_column :melting_transactions, :shippacketsend_date, :datetime
    add_column :melting_transactions, :envelope_file_name,:string, :limit=>100  
  end

  def self.down
    remove_column :melting_transactions, :shippacket_ship_via
    remove_column :melting_transactions, :shippacket_tracking_no
    remove_column :melting_transactions, :shippacketsend
    remove_column :melting_transactions, :shippacketsend_date
    remove_column :melting_transactions, :envelope_file_name
  end
end






