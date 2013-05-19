class AddColumnPrecisionToReportColumns < ActiveRecord::Migration
  def self.up
    add_column :report_columns, :column_precision , :integer
  end

  def self.down
    remove_column :report_columns, :column_precision
  end
end
