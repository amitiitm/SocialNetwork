class AddPriorityToMemos < ActiveRecord::Migration
  def self.up
    add_column :memos, :priority, :integer
    add_column :memos, :success, :boolean, :default => false
  end

  def self.down
    remove_column :memos, :success
    remove_column :memos, :priority
  end
end
