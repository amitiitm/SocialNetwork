class AlterMeltingTransactionSendofferwithvideo < ActiveRecord::Migration
  def self.up
    remove_column :melting_transactions, :sendvideowithoffer
    add_column :melting_transactions, :sendofferwithvideo, :string, :limit=>1, :default=>'N'  
  end

  def self.down
    remove_column :melting_transactions, :sendofferwithvideo
    add_column :melting_transactions, :sendvideowithoffer, :string, :limit=>1, :default=>'N'  
  end
end
