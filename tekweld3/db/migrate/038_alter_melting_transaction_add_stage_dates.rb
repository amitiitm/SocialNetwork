class AlterMeltingTransactionAddStageDates < ActiveRecord::Migration
  def self.up
    remove_column :melting_transactions,:updatemetalrate
    add_column :melting_transactions,:calculateoffer, :string, :limit=>1 , :default=>'N'
    remove_column :melting_transactions,:gold10kt_weight
    remove_column :melting_transactions,:gold14kt_weight
    remove_column :melting_transactions,:gold18kt_weight
    remove_column :melting_transactions,:gold24kt_weight
    add_column :melting_transactions,:gold10kt_weight, :decimal, :precision => 10, :scale => 5, :default => 0.0
    add_column :melting_transactions,:gold14kt_weight, :decimal, :precision => 10, :scale => 5, :default => 0.0
    add_column :melting_transactions,:gold18kt_weight, :decimal, :precision => 10, :scale => 5, :default => 0.0
    add_column :melting_transactions,:gold24kt_weight, :decimal, :precision => 10, :scale => 5, :default => 0.0

    add_column :melting_transactions,:receivepacket_date, :datetime
    add_column :melting_transactions,:sendvideo_date, :datetime
    add_column :melting_transactions,:attachvideo_date, :datetime
    add_column :melting_transactions,:calculateoffer_date, :datetime
    add_column :melting_transactions,:sendoffer_date, :datetime
    add_column :melting_transactions,:updatecustomerresponse_date, :datetime
    add_column :melting_transactions,:printcheck_date, :datetime
    add_column :melting_transactions,:updatecheckstatus_date, :datetime
    add_column :melting_transactions,:stoppayment_date, :datetime
    add_column :melting_transactions,:returnpacket_date, :datetime
    add_column :melting_transactions,:updatecommission_date, :datetime
    add_column :melting_transactions,:retailer_store_date, :datetime
    add_column :melting_transactions,:customer_comments_date, :datetime
    add_column :melting_transactions,:metalanalysis_date, :datetime
    add_column :melting_transactions,:firstofferreminder_date, :datetime
    add_column :melting_transactions,:secondofferreminder_date, :datetime
    add_column :melting_transactions,:firstdepositreminder_date, :datetime
    add_column :melting_transactions,:seconddepositreminder_date, :datetime
    add_column :melting_transactions,:verifycheck_date, :datetime

    add_column :melting_transactions,:total_value, :decimal, :precision => 12, :scale => 2, :default => 0.0
    
  end

  def self.down
    add_column :melting_transactions,:updatemetalrate, :string, :limit=>1 , :default=>'N'
    remove_column :melting_transactions,:calculateoffer
    add_column :melting_transactions,:gold10kt_weight, :decimal, :precision => 10, :scale => 3, :default => 0.0
    add_column :melting_transactions,:gold14kt_weight, :decimal, :precision => 10, :scale => 3, :default => 0.0
    add_column :melting_transactions,:gold18kt_weight, :decimal, :precision => 10, :scale => 3, :default => 0.0
    add_column :melting_transactions,:gold24kt_weight, :decimal, :precision => 10, :scale => 3, :default => 0.0
    remove_column :melting_transactions,:gold10kt_weight
    remove_column :melting_transactions,:gold14kt_weight
    remove_column :melting_transactions,:gold18kt_weight
    remove_column :melting_transactions,:gold24kt_weight

    remove_column :melting_transactions,:receivepacket_date
    remove_column :melting_transactions,:sendvideo_date
    remove_column :melting_transactions,:attachvideo_date
    remove_column :melting_transactions,:calculateoffer_date
    remove_column :melting_transactions,:sendoffer_date
    remove_column :melting_transactions,:updatecustomerresponse_date
    remove_column :melting_transactions,:printcheck_date
    remove_column :melting_transactions,:updatecheckstatus_date
    remove_column :melting_transactions,:stoppayment_date
    remove_column :melting_transactions,:returnpacket_date
    remove_column :melting_transactions,:updatecommission_date
    remove_column :melting_transactions,:retailer_store_date
    remove_column :melting_transactions,:customer_comments_date
    remove_column :melting_transactions,:metalanalysis_date
    remove_column :melting_transactions,:firstofferreminder_date
    remove_column :melting_transactions,:secondofferreminder_date
    remove_column :melting_transactions,:firstdepositreminder_date
    remove_column :melting_transactions,:seconddepositreminder_date
    remove_column :melting_transactions,:verifycheck_date

    remove_column :melting_transactions,:total_value
    
  end
end
