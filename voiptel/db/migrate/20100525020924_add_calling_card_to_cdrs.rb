class AddCallingCardToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :card_id, :integer
    add_column :cdrs, :tmp_phone_id, :integer
    add_index :cdrs, :card_id
    add_index :cdrs, :tmp_phone_id
  end

  def self.down
    remove_index :cdrs, :tmp_phone_id
    remove_index :cdrs, :card_id
    remove_column :cdrs, :tmp_phone_id
    remove_column :cdrs, :card_id
  end
end
