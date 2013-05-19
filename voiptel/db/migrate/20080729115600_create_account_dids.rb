class CreateAccountDids < ActiveRecord::Migration
  def self.up
    create_table :account_dids do |t|
      t.integer :account_id
      t.integer :did_id

      t.timestamps
    end
  end

  def self.down
    drop_table :account_dids
  end
end
