class AlterReportLayoutAddLockedcolumncount < ActiveRecord::Migration
  def self.up
    add_column :report_layouts, :lockedcolumncount, :integer, :default=>0
    remove_column :report_layout_columns, :lockedcolumncount
  end

  def self.down
    remove_column :report_layouts, :lockedcolumncount
    add_column :report_layout_columns, :lockedcolumncount, :integer, :default=>0
  end
end
