class CreatePhoneCards < ActiveRecord::Migration
  def self.up
    create_table :phone_cards do |t|
      t.integer :tmp_phone_id
      t.integer :card_id

      t.timestamps
    end
    add_index :phone_cards, :tmp_phone_id
    add_index :phone_cards, :card_id
  end

  def self.down
    remove_index :phone_cards, :card_id
    remove_index :phone_cards, :tmp_phone_id
    drop_table :phone_cards
  end
end
