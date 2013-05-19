class AlterReportsReportColumns < ActiveRecord::Migration
  def self.up
    add_column :reports, :isdrilldownrow,  :string, :limit=>1, :default => 'N'
    add_column :reports, :isfixedurl, :string, :limit=>1, :default => 'N'
    add_column :report_columns,  :isfixedurl, :string, :limit=>1, :default => 'N'
  end

  def self.down
    remove_column :reports, :isdrilldownrow, :isfixedurl
    remove_column :report_columns, :isfixedurl
  end
end
