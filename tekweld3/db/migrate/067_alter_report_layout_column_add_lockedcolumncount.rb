class AlterReportLayoutColumnAddLockedcolumncount < ActiveRecord::Migration
  def self.up
    add_column :report_layout_columns, :lockedcolumncount, :integer, :default=>0
  end

  def self.down
    remove_column :report_layout_columns, :lockedcolumncount
  end
end
