class AlterMeltingTransactionAddSendvideowithoffer < ActiveRecord::Migration
  def self.up
    remove_column :melting_transactions,:sendvideo
    remove_column :melting_transactions,:sendoffer
    add_column :melting_transactions,:sendvideowithoffer, :string, :limit=>1 , :default=>'N'
    remove_column :melting_transactions,:sendvideo_date
    add_column :melting_transactions,:sendvideowithoffer_date, :datetime
  end

  def self.down
    add_column :melting_transactions,:sendvideo, :string, :limit=>1 , :default=>'N'
    add_column :melting_transactions,:sendoffer, :string, :limit=>1 , :default=>'N'
    remove_column :melting_transactions,:sendvideowithoffer
    add_column :melting_transactions,:sendvideo_date, :datetime
    remove_column :melting_transactions,:sendvideowithoffer_date
  end
end
