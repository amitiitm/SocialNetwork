class AddTransferToTmpCreditCardInfo < ActiveRecord::Migration
  def self.up
    add_column :tmp_credit_card_infos, :transfer, :integer, :limit => 1, :default => 1
  end

  def self.down
    remove_column :tmp_credit_card_infos, :transfer
  end
end
