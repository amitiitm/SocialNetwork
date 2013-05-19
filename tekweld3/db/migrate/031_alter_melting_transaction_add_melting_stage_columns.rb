class AlterMeltingTransactionAddMeltingStageColumns < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions,:receivepacket,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:sendvideo,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:attachvideo,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:updatemetalrate,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:sendoffer,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:updatecustomerresponse,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:printcheck,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:sendreminder,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:updatecheckstatus,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:stoppayment,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:returnpacket,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:updatecommission,:string,:limit=>1 ,:default => "N" 
    remove_column :melting_transactions, :video_recorded_flag
    remove_column :melting_transactions, :metal_info_updated_flag
    remove_column :melting_transactions, :pre_offer_sent_flag
    remove_column :melting_transactions, :offer_sent_flag
    remove_column :melting_transactions, :check_print_flag
    remove_column :melting_transactions, :check_sent_flag
    remove_column :melting_transactions, :check_encashed_flag
    remove_column :melting_transactions, :reminder_sent_flag
    remove_column :melting_transactions, :stop_payment_flag
    remove_column :melting_transactions, :goods_returned_flag
    remove_column :melting_transactions, :video_attached_flag
  end

  def self.down
    remove_column :melting_transactions,:receivepacket
    remove_column :melting_transactions,:sendvideo
    remove_column :melting_transactions,:attachvideo
    remove_column :melting_transactions,:updatemetalrate
    remove_column :melting_transactions,:sendoffer
    remove_column :melting_transactions,:updatecustomerresponse
    remove_column :melting_transactions,:printcheck
    remove_column :melting_transactions,:sendreminder
    remove_column :melting_transactions,:updatecheckstatus 
    remove_column :melting_transactions,:stoppayment
    remove_column :melting_transactions,:returnpacket 
    remove_column :melting_transactions,:updatecommission
    add_column :melting_transactions, :video_recorded_flag,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions, :metal_info_updated_flag,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions, :pre_offer_sent_flag,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions, :offer_sent_flag,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions, :check_print_flag,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions, :check_sent_flag,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions, :check_encashed_flag,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions, :reminder_sent_flag,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions, :stop_payment_flag,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions, :goods_returned_flag,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions, :video_attached_flag,:string,:limit=>1 ,:default => "N" 
  end
end


