class AddAccountIdToTmpCreditCardInfos < ActiveRecord::Migration
  def self.up
    add_column :tmp_credit_card_infos, :account_id, :integer
  end

  def self.down
    remove_column :tmp_credit_card_infos, :account_id
  end
end
