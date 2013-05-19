class RenameAdminUserCold < ActiveRecord::Migration
  def self.up
    rename_column :memos, :created_by, :created_by_id
    rename_column :memos, :assigned_to, :assigned_to_id
  end

  def self.down
    rename_column :memos, :assigned_to_id, :assigned_to
    rename_column :memos, :created_by, :created_by_id

  end
end
