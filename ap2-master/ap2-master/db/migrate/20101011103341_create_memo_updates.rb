class CreateMemoUpdates < ActiveRecord::Migration
  def self.up
    create_table :memo_updates do |t|
      t.text :content
      t.integer :admin_user_id
      t.integer :contact_type
      t.integer :result

      t.timestamps
    end
  end

  def self.down
    drop_table :memo_updates
  end
end
