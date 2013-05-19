class CreateAccountNumbers < ActiveRecord::Migration
  def self.up
    create_table :account_numbers do |t|
      t.integer :number

      t.timestamps
    end
  end

  def self.down
    drop_table :account_numbers
  end
end
