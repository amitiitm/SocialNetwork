class AlterMeltingTransactionAddMetalanalysis < ActiveRecord::Migration
  def self.up
    add_column :melting_transactions,:metalanalysis,:string,:limit=>1 ,:default => "N" 
    add_column :melting_transactions,:analysis_accept_reject_flag,:string,:limit=>1
    add_column :melting_transactions,:return_pkt_video_file_name,:string,:limit=>50
  end

  def self.down
    remove_column :melting_transactions,:metalanalysis
    remove_column :melting_transactions,:analysis_accept_reject_flag
    remove_column :melting_transactions,:return_pkt_video_file_name
  end
end
