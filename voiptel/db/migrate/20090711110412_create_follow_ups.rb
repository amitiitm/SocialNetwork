class CreateFollowUps < ActiveRecord::Migration
  def self.up
    create_table :follow_ups do |t|
      t.text :note
      t.date :action_date
      t.integer :follow_up_action_id
      t.integer :account_id
      t.integer :user_id
      t.integer :admin_user_id
      t.integer :last_follow_up_id

      t.timestamps
    end
  end

  def self.down
    drop_table :follow_ups
  end
end
