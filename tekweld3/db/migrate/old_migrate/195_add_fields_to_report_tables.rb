class  AddFieldsToReportTables < ActiveRecord::Migration
  def self.up
    add_column :report_columns, :print_width, :integer
    add_column :report_layout_columns, :print_width, :integer
  end

  def self.down
    remove_column :report_columns, :print_width
    remove_column :report_layout_columns, :print_width
  end
end
