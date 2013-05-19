class AddCreatedByToMemos < ActiveRecord::Migration
  def self.up
    add_column :memos, :created_by, :integer
  end

  def self.down
    remove_column :memos, :created_by
  end
end
