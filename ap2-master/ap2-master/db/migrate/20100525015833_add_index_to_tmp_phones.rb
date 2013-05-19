class AddIndexToTmpPhones < ActiveRecord::Migration
  def self.up
    add_index :tmp_phones, :number, :unique => true
    add_index :tmp_phones, :card_id
  end

  def self.down
    remove_index :tmp_phones, :card_id
    remove_index :tmp_phones, :column => :number
  end
end
