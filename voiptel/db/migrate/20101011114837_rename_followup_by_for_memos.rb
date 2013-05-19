class RenameFollowupByForMemos < ActiveRecord::Migration
  def self.up
    rename_column :memos, :followup_by, :followup_by_id
  end

  def self.down
    rename_column :memo_updates, :followup_by_id, :followup_by
  end
end
