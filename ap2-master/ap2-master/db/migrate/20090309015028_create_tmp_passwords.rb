class CreateTmpPasswords < ActiveRecord::Migration
  def self.up
    create_table :tmp_passwords do |t|
      t.string :password
      t.integer :auth_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tmp_passwords
  end
end
