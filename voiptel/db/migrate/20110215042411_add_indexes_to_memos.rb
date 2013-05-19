class AddIndexesToMemos < ActiveRecord::Migration
  def self.up
    add_index :memos, :memoable_id
    add_index :memos, :memoable_type
  end

  def self.down
    remove_index :memos, :memoable_type
    remove_index :memos, :memoable_id
    mind
  end
end