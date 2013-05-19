class CreateTmpCreditCardInfos < ActiveRecord::Migration
  def self.up
    create_table :tmp_credit_card_infos do |t|
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.integer :address_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tmp_credit_card_infos
  end
end
