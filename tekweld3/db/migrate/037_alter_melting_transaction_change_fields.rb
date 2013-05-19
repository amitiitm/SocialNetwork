class AlterMeltingTransactionChangeFields < ActiveRecord::Migration
  def self.up
    remove_column :melting_transactions,:silver_rate
    remove_column :melting_transactions,:platinum_rate
    remove_column :melting_transactions,:paladdium_rate
    remove_column :melting_transactions,:total_gold_wt
    remove_column :melting_transactions,:total_silver_wt
    remove_column :melting_transactions,:total_platinum_wt
    remove_column :melting_transactions,:total_paladdium_wt  
    remove_column :melting_transactions,:sendreminder  
    add_column :melting_transactions,:gold_rate_date, :datetime
    add_column :melting_transactions,:firstofferreminder, :string, :limit=>1 , :default=>'N'
    add_column :melting_transactions,:secondofferreminder, :string, :limit=>1 , :default=>'N'
    add_column :melting_transactions,:firstdepositreminder, :string, :limit=>1 , :default=>'N'
    add_column :melting_transactions,:seconddepositreminder, :string, :limit=>1 , :default=>'N'
    add_column :melting_transactions,:verifycheck, :string, :limit=>1 , :default=>'N'
    add_column :melting_transactions,:gold10kt_weight, :decimal, :precision => 7, :scale => 3, :default => 0.0
    add_column :melting_transactions,:gold14kt_weight, :decimal, :precision => 7, :scale => 3, :default => 0.0
    add_column :melting_transactions,:gold18kt_weight, :decimal, :precision => 7, :scale => 3, :default => 0.0
    add_column :melting_transactions,:gold24kt_weight, :decimal, :precision => 7, :scale => 3, :default => 0.0
    add_column :melting_transactions,:barcode, :string, :limit=>10
    add_column :melting_transactions,:reject_reason_code, :string, :limit=>25
    
  end

  def self.down
    add_column :melting_transactions,:silver_rate, :decimal,             :precision => 12, :scale => 2, :default => 0.0
    add_column :melting_transactions,:platinum_rate, :decimal,             :precision => 12, :scale => 2, :default => 0.0
    add_column :melting_transactions,:paladdium_rate, :decimal,             :precision => 12, :scale => 2, :default => 0.0
    add_column :melting_transactions,:total_gold_wt, :decimal,         :precision => 12, :scale => 2, :default => 0.0
    add_column :melting_transactions,:total_silver_wt, :decimal,         :precision => 12, :scale => 2, :default => 0.0
    add_column :melting_transactions,:total_platinum_wt, :decimal,         :precision => 12, :scale => 2, :default => 0.0
    add_column :melting_transactions,:total_paladdium_wt  , :decimal,         :precision => 12, :scale => 2, :default => 0.0
    remove_column :melting_transactions,:gold_rate_date
    remove_column :melting_transactions,:firstofferreminder
    remove_column :melting_transactions,:secondofferreminder
    remove_column :melting_transactions,:firstdepositreminder
    remove_column :melting_transactions,:seconddepositreminder
    remove_column :melting_transactions,:verifycheck
    remove_column :melting_transactions,:gold10kt_weight
    remove_column :melting_transactions,:gold14kt_weight
    remove_column :melting_transactions,:gold18kt_weight
    remove_column :melting_transactions,:gold24kt_weight
    remove_column :melting_transactions,:reject_reason_code
  end
end
