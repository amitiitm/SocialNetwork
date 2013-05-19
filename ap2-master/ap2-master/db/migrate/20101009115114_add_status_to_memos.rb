class AddStatusToMemos < ActiveRecord::Migration
  def self.up
    add_column :memos, :status, :integer
  end

  def self.down
    remove_column :memos, :status
  end
end
