class CreateAssignedDids < ActiveRecord::Migration
  def self.up
    create_table :assigned_dids do |t|
      t.integer :account_id
      t.integer :user_id
      t.integer :phone_id
      t.integer :did_id
      t.integer :area_code_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assigned_dids
  end
end
