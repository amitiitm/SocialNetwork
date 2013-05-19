class CreateRecordings < ActiveRecord::Migration
  def self.up
    create_table :recordings do |t|
      t.string :file_name
      t.integer :account_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :recordings
  end
end
