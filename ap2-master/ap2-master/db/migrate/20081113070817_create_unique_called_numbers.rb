class CreateUniqueCalledNumbers < ActiveRecord::Migration
  def self.up
    create_table :unique_called_numbers do |t|
      t.string :phone_number
      t.string :unique_number
      t.integer :freq
      t.integer :account_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :unique_called_numbers
  end
end
