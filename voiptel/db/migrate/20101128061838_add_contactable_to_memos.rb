class AddContactableToMemos < ActiveRecord::Migration
  def self.up
    add_column :memos, :contactable_type, :string, :limit => 10
    add_column :memos, :contactable_id, :integer
  end

  def self.down
    remove_column :memos, :contactable_id
    remove_column :memos, :contactable_type
  end
end
