class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :gender, :limit => 1
      t.date :dob
      t.string :email
      t.integer :account_status, :limit => 1
      t.integer :relationship
      t.integer :account_id      

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
