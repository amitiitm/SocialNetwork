class AddAdminUserIdToTmpCreditCardInfos < ActiveRecord::Migration
  def self.up
    add_column :tmp_credit_card_infos, :admin_user_id, :integer
  end

  def self.down
    remove_column :tmp_credit_card_infos, :admin_user_id
  end
end
