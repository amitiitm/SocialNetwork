class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :number
      t.string :pin, :limit => 6
      t.integer :status, :limit => 1
      t.integer :minutes
      t.integer :account_holder_id

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
